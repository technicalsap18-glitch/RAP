CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE Travel.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Travel.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Travel.

    METHODS read FOR READ
      IMPORTING keys FOR READ Travel RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Travel.

    METHODS rba_Booking FOR READ
      IMPORTING keys_rba FOR READ Travel\_Booking FULL result_requested RESULT result LINK association_links.

    METHODS cba_Booking FOR MODIFY
      IMPORTING entities_cba FOR CREATE Travel\_Booking.
    TYPES: tt_failed TYPE TABLE FOR FAILED zi_dxtravel_u\\Travel.
    TYPES: tt_reported TYPE TABLE FOR REPORTED zi_dxtravel_u\\Travel.
    METHODS map_messages
      IMPORTING
        cid          TYPE abp_behv_cid OPTIONAL
        travel_id    TYPE /dmo/travel_id OPTIONAL
        messages     TYPE /dmo/t_message
      EXPORTING
        failed_added TYPE abap_boolean
      CHANGING
        failed       TYPE tt_failed
        reported     TYPE tt_reported.

    TYPES: tt_failed_cba TYPE TABLE FOR FAILED zi_dxtravel_u\\Booking.
    TYPES: tt_reported_cba TYPE TABLE FOR REPORTED zi_dxtravel_u\\Booking.

    METHODS map_messages_assoc_to_booking
      IMPORTING
        cid          TYPE abp_behv_cid
        messages     TYPE /dmo/t_message
        is_depedend  TYPE abap_boolean OPTIONAL
      EXPORTING
        failed_added TYPE abap_boolean
      CHANGING
        failed       TYPE tt_failed_cba
        reported     TYPE tt_reported_cba.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.
    DATA ls_travel_in TYPE /dmo/travel.
    DATA: ls_travel_out TYPE /dmo/travel,
          lt_messages   TYPE /dmo/t_message.
    LOOP AT entities INTO DATA(ls_entity).
      ls_travel_in = CORRESPONDING #( ls_entity MAPPING FROM ENTITY USING CONTROL ).

      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_CREATE'
        EXPORTING
          is_travel         = CORRESPONDING /dmo/s_travel_in( ls_travel_in )
          iv_numbering_mode = /dmo/if_flight_legacy=>numbering_mode-late
        IMPORTING
          es_travel         = ls_travel_out
          et_messages       = lt_messages.

      map_messages(
       EXPORTING
       cid = ls_entity-%cid
       messages = lt_messages
       IMPORTING
       failed_added = DATA(lv_failed_add)
       CHANGING
       failed = failed-travel
       reported = reported-travel
      ).

      IF lv_failed_add = abap_false.
        INSERT VALUE #( %cid = ls_entity-%cid
          TravelId = ls_travel_out-travel_id ) INTO TABLE  mapped-travel.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    DATA: ls_travel_in TYPE /dmo/travel,
          ls_travelx   TYPE /dmo/s_travel_inx,
          lt_messages  TYPE /dmo/t_message.

    LOOP AT entities INTO DATA(ls_entity).
      ls_travel_in = CORRESPONDING #( ls_entity MAPPING FROM ENTITY ).
      ls_travelx-travel_id = ls_entity-TravelId.
      ls_travelx-_intx = CORRESPONDING #( ls_entity MAPPING FROM ENTITY ).


      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_UPDATE'
        EXPORTING
          is_travel   = CORRESPONDING /dmo/s_travel_in( ls_travel_in )
          is_travelx  = ls_travelx
        IMPORTING
          et_messages = lt_messages.

      map_messages(
        EXPORTING
          cid          = ls_entity-%cid_ref
          travel_id    = ls_entity-TravelId
          messages     = lt_messages
        CHANGING
          failed       = failed-travel
          reported     = reported-travel ).

    ENDLOOP.

  ENDMETHOD.

  METHOD delete.
    DATA:lt_messages  TYPE /dmo/t_message.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_keys>).
      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_DELETE'
        EXPORTING
          iv_travel_id = <ls_keys>-TravelId
        IMPORTING
          et_messages  = lt_messages.

      map_messages(
        EXPORTING
          cid          = <ls_keys>-%cid_ref
          travel_id    = <ls_keys>-TravelId
          messages     = lt_messages
        CHANGING
          failed       = failed-travel
          reported     = reported-travel
      ).
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    DATA: ls_travel_out TYPE /dmo/travel,
          lt_messages   TYPE /dmo/t_message.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_keys>) GROUP BY <ls_keys>-%tky.
      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_READ'
        EXPORTING
          iv_travel_id = <ls_keys>-TravelId
*         iv_include_buffer     = abap_true
        IMPORTING
          es_travel    = ls_travel_out
          et_messages  = lt_messages.

      map_messages(
     EXPORTING
       travel_id    = <ls_keys>-TravelId
       messages     = lt_messages
      IMPORTING
      failed_added = DATA(failed_added)
     CHANGING
       failed       = failed-travel
       reported     = reported-travel ).
      IF failed_added = abap_false.
        INSERT CORRESPONDING #( ls_travel_out MAPPING TO ENTITY  ) INTO TABLE result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD lock.
    DATA: lo_lock_fail TYPE REF TO cx_abap_lock_failure.
    TRY.
        DATA(lr_lock) = cl_abap_lock_object_factory=>get_instance( iv_name = '/DMO/ETRAVEL'  ).
      CATCH cx_abap_lock_failure INTO DATA(lo_lock).
        RAISE SHORTDUMP lo_lock.
    ENDTRY.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_keys>).
      TRY.
          lr_lock->enqueue(
*             it_table_mode =
            it_parameter  = VALUE #( ( name = 'TRAVEL_ID' value = REF #( <ls_keys>-TravelId ) ) )
*             _scope        =
*             _wait         =
          ).
        CATCH cx_abap_foreign_lock INTO DATA(lr_fo_lock).
          map_messages(
            EXPORTING
*                  cid          =
              travel_id    = <ls_keys>-TravelId
              messages     = VALUE #( ( msgid = '/DMO/CM_FLIGHT_LEGAC'
                                        msgty = 'E'
                                        msgno = '032'
                                        msgv1 = <ls_keys>-TravelId
                                        msgv2 = lr_fo_lock->user_name  ) )
*                IMPORTING
*                  failed_added =
            CHANGING
              failed       = failed-travel
              reported     = reported-travel
          ).
        CATCH cx_abap_lock_failure INTO lo_lock_fail.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.

  METHOD rba_Booking.
    DATA: travel_out TYPE /dmo/travel,
          booking_out TYPE /dmo/t_booking,
          booking LIKE LINE OF result,
          messages TYPE /dmo/t_message.
    loop at keys_rba assigning FIELD-SYMBOL(<ls_keys_rba>) GROUP BY <ls_keys_rba>-TravelId.

      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_READ'
        EXPORTING
          iv_travel_id          = <ls_keys_rba>-TravelId
*          iv_include_buffer     = abap_true
        IMPORTING
          es_travel             = travel_out
          et_booking            = booking_out
          et_messages           = messages.

       map_messages(
         EXPORTING
           travel_id    = <ls_keys_rba>-TravelId
           messages     = messages
         IMPORTING
           failed_added = DATA(failed_added)
         CHANGING
           failed       = failed-travel
           reported     = reported-travel
       ).
      if failed_added = abap_false.
        LOOP AT booking_out ASSIGNING FIELD-SYMBOL(<booking>).
           INSERT VALUE #(
           source-%tky = <ls_keys_rba>-%tky
           target-%tky = VALUE #(
           TravelID = <booking>-travel_id
           BookingID = <booking>-booking_id
           ) )
            INTO TABLE association_links.

           if result_requested = abap_true.
             booking = CORRESPONDING #( <booking> MAPPING TO ENTITY ).
             INSERT booking INTO TABLE result.
           endif.
        ENDLOOP.
      endif.
    endloop.

    SORT association_links BY target ASCENDING.
    DELETE ADJACENT DUPLICATES FROM association_links COMPARING ALL FIELDS.

    SORT result BY %tky ASCENDING.
    DELETE ADJACENT DUPLICATES FROM result COMPARING ALL FIELDS.
  ENDMETHOD.

  METHOD cba_Booking.
    DATA: booking_old     TYPE /dmo/t_booking,
          messages        TYPE /dmo/t_message,
          booking         TYPE /dmo/booking,
          last_booking_id TYPE /dmo/booking_id VALUE '0'.

    LOOP AT entities_cba ASSIGNING FIELD-SYMBOL(<travel>).
      DATA(travelid) = <travel>-TravelId.

      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_READ'
        EXPORTING
          iv_travel_id = travelid
        IMPORTING
          et_booking   = booking_old
          et_messages  = messages.

      map_messages(
        EXPORTING
          cid          = <travel>-%cid_ref
          travel_id    = <travel>-TravelId
          messages     = messages
        IMPORTING
          failed_added = DATA(failed_added)
        CHANGING
          failed       = failed-travel
          reported     = reported-travel
      ).

      IF failed_added = abap_true.
        LOOP AT <travel>-%target ASSIGNING FIELD-SYMBOL(<booking>).
          map_messages_assoc_to_booking(
          EXPORTING
           cid = <booking>-%cid
           is_depedend = abap_true
           messages = messages
           CHANGING
           failed = failed-booking
           reported = reported-booking
          ).

        ENDLOOP.
      ELSE.
        last_booking_id = VALUE #( booking_old[ lines( booking_old ) ]-booking_id OPTIONAL ).

        LOOP AT <travel>-%target  ASSIGNING FIELD-SYMBOL(<booking_create>).
          booking = CORRESPONDING #( <booking_create> MAPPING FROM ENTITY USING CONTROL ).
          last_booking_id += 1.
          booking-booking_id = last_booking_id.

          CALL FUNCTION '/DMO/FLIGHT_TRAVEL_UPDATE'
            EXPORTING
              is_travel   = VALUE /dmo/s_travel_in( travel_id = travelid )
              is_travelx  = VALUE /dmo/s_travel_inx( travel_id = travelid )
              it_booking  = VALUE /dmo/t_booking_in( ( CORRESPONDING #( booking ) ) )
              it_bookingx = VALUE /dmo/t_booking_inx(
              (
                booking_id = booking-booking_id
                action_code = /dmo/if_flight_legacy=>action_code-create
               ) )
            IMPORTING
              et_messages = messages.

          map_messages_assoc_to_booking(
       EXPORTING
        cid = <booking_create>-%cid
        messages = messages
        IMPORTING
        failed_added = failed_added
        CHANGING
        failed = failed-booking
        reported = reported-booking
       ).
          IF failed_added = abap_false.
            INSERT VALUE #(
               %cid = <booking_create>-%cid
               travelid = travelid
               bookingid = booking-booking_id
             ) INTO TABLE mapped-booking.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD map_messages.
    failed_added = abap_false.
    LOOP AT messages ASSIGNING FIELD-SYMBOL(<ls_messages>).

      IF <ls_messages>-msgty = 'E' OR <ls_messages>-msgty = 'A'.
        APPEND VALUE #( %cid = cid
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


  METHOD map_messages_assoc_to_booking.
    failed_added = abap_false.
    LOOP AT messages ASSIGNING FIELD-SYMBOL(<ls_messages>).

      IF <ls_messages>-msgty = 'E' OR <ls_messages>-msgty = 'A'.
        APPEND VALUE #( %cid = cid
                         %fail-cause = zcl_dxtravel_aux=>get_cause_from_message(
                                         msgid         = <ls_messages>-msgid
                                         msgno         = <ls_messages>-msgno
                                          is_dependened = abap_false
                                       ) ) TO failed.
        failed_added = abap_true.
      ENDIF.

      reported = VALUE #(  (
         %cid = cid
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
