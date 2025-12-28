CLASS lhc_Booking DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Booking.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Booking.

    METHODS read FOR READ
      IMPORTING keys FOR READ Booking RESULT result.

    METHODS rba_Travel FOR READ
      IMPORTING keys_rba FOR READ Booking\_Travel FULL result_requested RESULT result LINK association_links.

    TYPES: tt_failed TYPE TABLE FOR FAILED zi_dxbooking_u.
    TYPES: tt_reported TYPE TABLE FOR REPORTED zi_dxbooking_u.

    METHODS map_messages
      IMPORTING
        cid       TYPE abp_behv_cid OPTIONAL
        travel_id TYPE /dmo/travel_id OPTIONAL
        booking_id TYPE /dmo/booking_id OPTIONAL
        messages  TYPE /dmo/t_message
      EXPORTING
        failed_added TYPE abap_boolean
      CHANGING
        failed    TYPE tt_failed
        reported  TYPE tt_reported.

ENDCLASS.

CLASS lhc_Booking IMPLEMENTATION.

  METHOD update.

  DATA: ls_booking_in TYPE /dmo/booking,
          ls_bookingx   TYPE /dmo/s_booking_inx,
          lt_messages  TYPE /dmo/t_message.

    LOOP AT entities INTO DATA(ls_entity).
      ls_booking_in = CORRESPONDING #( ls_entity MAPPING FROM ENTITY ).

      ls_bookingx-booking_id = ls_entity-BookingId.
      ls_bookingx-action_code = /dmo/if_flight_legacy=>action_code-update.
      ls_bookingx-_intx = CORRESPONDING #( ls_entity MAPPING FROM ENTITY ).


      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_UPDATE'
        EXPORTING

          is_travel    = VALUE /dmo/s_travel_in( travel_id = ls_entity-travelid )
          is_travelx    = VALUE /dmo/s_travel_inx( travel_id = ls_entity-travelid )
          it_booking   = VALUE /dmo/t_booking_in( ( CORRESPONDING #( ls_booking_in ) ) )
          it_bookingx  = VALUE /dmo/t_booking_inx( ( ls_bookingx ) )
        IMPORTING
          et_messages = lt_messages.

      map_messages(
        EXPORTING
          cid          = ls_entity-%cid_ref
          travel_id    = ls_entity-TravelId
          booking_id   = ls_entity-BookingId
          messages     = lt_messages
        CHANGING
          failed       = failed-booking
          reported     = reported-booking ).

    ENDLOOP.

  ENDMETHOD.

  METHOD delete.
    DATA:lt_messages  TYPE /dmo/t_message.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_keys>).
      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_UPDATE'
        EXPORTING
          is_travel              = VALUE /dmo/s_travel_in( travel_id = <ls_keys>-TravelId )
          is_travelx             = VALUE /dmo/s_travel_inx( travel_id = <ls_keys>-TravelId )
          it_booking             = VALUE /dmo/t_booking_in( ( booking_id = <ls_keys>-BookingId ) )
          it_bookingx            = VALUE /dmo/t_booking_inx( ( booking_id = <ls_keys>-BookingId
                                                               action_code = /dmo/if_flight_legacy=>action_code-delete ) )
        IMPORTING
          et_messages  = lt_messages.

      map_messages(
        EXPORTING
          cid          = <ls_keys>-%cid_ref
          travel_id    = <ls_keys>-TravelId
          booking_id  = <ls_keys>-BookingId
          messages     = lt_messages
        CHANGING
          failed       = failed-booking
          reported     = reported-booking
      ).
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Travel.
      DATA: travel_out TYPE /dmo/travel,
          travel LIKE LINE OF result,
          messages TYPE /dmo/t_message.
    loop at keys_rba assigning FIELD-SYMBOL(<ls_keys_rba>) GROUP BY <ls_keys_rba>-TravelId.

      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_READ'
        EXPORTING
          iv_travel_id          = <ls_keys_rba>-TravelId
*          iv_include_buffer     = abap_true
        IMPORTING
          es_travel             = travel_out
          et_messages           = messages.

       map_messages(
         EXPORTING
           travel_id    = <ls_keys_rba>-TravelId
           booking_id    = <ls_keys_rba>-BookingId
           messages     = messages
         IMPORTING
           failed_added = DATA(failed_added)
         CHANGING
           failed       = failed-booking
           reported     = reported-booking
       ).
      if failed_added = abap_false.
        LOOP AT keys_rba ASSIGNING FIELD-SYMBOL(<travel>) USING KEY entity
                                       WHERE TravelId = <ls_keys_rba>-TravelId.
           INSERT VALUE #(
           source-%tky = <travel>-%tky
           target-travelid = <travel>-TravelId
           )
            INTO TABLE association_links.

           if result_requested = abap_true.
             APPEND CORRESPONDING #( travel_out MAPPING TO ENTITY )
             TO result.
           endif.
        ENDLOOP.
      endif.
    endloop.

    SORT association_links BY source ASCENDING.
    DELETE ADJACENT DUPLICATES FROM association_links COMPARING ALL FIELDS.

    SORT result BY %tky ASCENDING.
    DELETE ADJACENT DUPLICATES FROM result COMPARING ALL FIELDS.
  ENDMETHOD.


  METHOD map_messages.
  failed_added = abap_false.
    LOOP AT messages ASSIGNING FIELD-SYMBOL(<ls_messages>).

      IF <ls_messages>-msgty = 'E' OR <ls_messages>-msgty = 'A'.
        APPEND VALUE #( %cid = cid
                        travelid =  travel_id
                        bookingid = booking_id
                         %fail-cause = zcl_dxtravel_aux=>get_cause_from_message(
                                         msgid         = <ls_messages>-msgid
                                         msgno         = <ls_messages>-msgno
*                                          is_dependened = abap_false
                                       ) ) TO failed.
        failed_added = abap_true.
      ENDIF.

      reported = VALUE #(  (
         %cid = cid
         TravelId = travel_id
         BookingID = booking_id
         %msg = new_message(
                  id       = <ls_messages>-msgid
                  number   = <ls_messages>-msgno
                  severity = if_abap_behv_message=>severity-error
                  v1       = <ls_messages>-msgv1
                  v2       = <ls_messages>-msgv2
                  v3       = <ls_messages>-msgv3
                  v4       = <ls_messages>-msgv4
                ) )
        ).
   ENDLOOP.
  ENDMETHOD.

ENDCLASS.
