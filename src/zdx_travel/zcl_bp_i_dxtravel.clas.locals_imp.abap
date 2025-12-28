CLASS lsc_zi_dxtravel DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_dxtravel IMPLEMENTATION.

  METHOD save_modified.
*    DATA : lt_travel_log TYPE STANDARD TABLE OF zdx_log_tab.
*    DATA : lt_travel_log_c TYPE STANDARD TABLE OF zdx_log_tab.
*    DATA : lt_travel_log_u TYPE STANDARD TABLE OF zdx_log_tab.
*
*    IF  create-zi_dxtravel IS NOT INITIAL.
*
*      lt_travel_log = CORRESPONDING #( create-zi_dxtravel ).
*
*      LOOP AT lt_travel_log ASSIGNING FIELD-SYMBOL(<ls_travel_log>).
*
*        <ls_travel_log>-changing_operation = 'CREATE'.
*        GET TIME STAMP FIELD <ls_travel_log>-created_at.
*
*        READ TABLE create-zi_dxtravel  ASSIGNING FIELD-SYMBOL(<ls_travel>)
*                                 WITH TABLE KEY entity
*                                 COMPONENTS TravelId = <ls_travel_log>-travelid.
*        IF sy-subrc IS INITIAL.
*
*          IF <ls_travel>-%control-BookingFee = cl_abap_behv=>flag_changed.
*            <ls_travel_log>-changed_field_name = 'Booking Fee'.
*            <ls_travel_log>-changed_value  = <ls_travel>-BookingFee.
*            TRY.
*                <ls_travel_log>-change_id = cl_system_uuid=>create_uuid_x16_static( ).
*              CATCH cx_uuid_error.
*                "handle exception
*            ENDTRY.
*
*            APPEND <ls_travel_log> TO lt_travel_log_c.
*
*          ENDIF.
*          IF <ls_travel>-%control-OverallStatus = cl_abap_behv=>flag_changed.
*            <ls_travel_log>-changed_field_name = 'Overall Status'.
*            <ls_travel_log>-changed_value  = <ls_travel>-OverallStatus.
*            TRY.
*                <ls_travel_log>-change_id = cl_system_uuid=>create_uuid_x16_static( ).
*              CATCH cx_uuid_error.
*                "handle exception
*            ENDTRY.
*
*            APPEND <ls_travel_log> TO lt_travel_log_c.
*
*          ENDIF.
*
*        ENDIF.
*      ENDLOOP.
*
*      INSERT  zdx_log_tab FROM TABLE @lt_travel_log_c.
*    ENDIF.
*
*
*    IF  update-zi_dxtravel IS NOT INITIAL.
*      lt_travel_log = CORRESPONDING #( update-zi_dxtravel ).
*
*      LOOP AT update-zi_dxtravel ASSIGNING FIELD-SYMBOL(<ls_log_update>).
*        ASSIGN lt_travel_log[ travelid = <ls_log_update>-travelid ] TO FIELD-SYMBOL(<ls_log_u>).
*
*        <ls_log_u>-changing_operation = 'UPDATE'.
*        GET TIME STAMP FIELD <ls_log_u>-created_at.
*
*        IF <ls_log_update>-%control-customerid = if_abap_behv=>mk-on.
*          <ls_log_u>-changed_value = <ls_log_update>-customerid.
*          TRY.
*              <ls_log_u>-change_id = cl_system_uuid=>create_uuid_x16_static( ) .
*            CATCH cx_uuid_error.
*          ENDTRY.
*          <ls_log_u>-changed_field_name = 'customer_id'.
*          APPEND <ls_log_u> TO lt_travel_log_u.
*        ENDIF.
*
*        IF <ls_log_update>-%control-description = if_abap_behv=>mk-on.
*          <ls_log_u>-changed_value = <ls_log_update>-description.
*          TRY.
*              <ls_log_u>-change_id = cl_system_uuid=>create_uuid_x16_static( ) .
*            CATCH cx_uuid_error.
*          ENDTRY.
*          <ls_log_u>-changed_field_name = 'description'.
*          APPEND <ls_log_u> TO lt_travel_log_u.
*        ENDIF.
*      ENDLOOP.
*      INSERT zdx_log_tab FROM TABLE @lt_travel_log_u.
*    ENDIF.
*
*
*    IF  delete-zi_dxtravel IS NOT INITIAL.
*
*      lt_travel_log = CORRESPONDING #( delete-zi_dxtravel ).
*      LOOP AT lt_travel_log ASSIGNING FIELD-SYMBOL(<ls_log_del>).
*        <ls_log_del>-changing_operation = 'DELETE'.
*        GET TIME STAMP FIELD <ls_log_del>-created_at.
*        TRY.
*            <ls_log_del>-change_id = cl_system_uuid=>create_uuid_x16_static( ) .
*          CATCH cx_uuid_error.
*            "handle exception
*        ENDTRY.
*      ENDLOOP.
*
*      " Inserts rows specified in lt_travel_log into the DB table /dmo/log_travel
*      INSERT zdx_log_tab FROM TABLE @lt_travel_log.
*
*    ENDIF.
*
***********************************************************************
***********************************************************************
*
*    DATA: lt_book_suppl TYPE STANDARD TABLE OF ybooksupp_tech_m.
*    IF create-zdx_booksupp IS NOT INITIAL.
*
*      lt_book_suppl = VALUE #( FOR ls_booksup IN  create-zdx_booksupp (
*                                           travel_id  = ls_booksup-TravelId
*                                           booking_id = ls_booksup-BookingId
*                                           booking_supplement_id  = ls_booksup-BookingSupplementId
*                                           supplement_id   = ls_booksup-SupplementId
*                                           price   = ls_booksup-Price
*                                           currency_code    = ls_booksup-CurrencyCode
*                                           last_changed_at = ls_booksup-LastChangedAt
*                                             )  ).
*
*      INSERT /dmo/booksuppl_m FROM TABLE @lt_book_suppl.
*
*    ENDIF.
*    IF update-zdx_b IS NOT INITIAL.
*
*      lt_book_suppl = VALUE #( FOR ls_booksup IN  update-zdx_booksupp (
*                                        travel_id  = ls_booksup-TravelId
*                                        booking_id = ls_booksup-BookingId
*                                        booking_supplement_id  = ls_booksup-BookingSupplementId
*                                        supplement_id   = ls_booksup-SupplementId
*                                        price   = ls_booksup-Price
*                                        currency_code    = ls_booksup-CurrencyCode
*                                        last_changed_at = ls_booksup-LastChangedAt
*                                          )  ).
*
*
*      UPDATE /dmo/booksuppl_m FROM TABLE @lt_book_suppl.
*
*    ENDIF.
*    IF delete-zdx_booksupp IS NOT INITIAL.
*
*      lt_book_suppl = VALUE #( FOR ls_del IN  delete-zdx_booksupp (
*                                         travel_id  = ls_del-TravelId
*                                         booking_id = ls_del-BookingId
*                                         booking_supplement_id  = ls_del-BookingSupplementId
*                                           )  ).
*
*
*      DELETE /dmo/booksuppl_m FROM TABLE @lt_book_suppl.
*
*    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZI_DXTRAVEL DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_dxtravel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_dxtravel RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_dxtravel RESULT result.

    METHODS accepttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_dxtravel~accepttravel RESULT result.

    METHODS copytravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_dxtravel~copytravel.

    METHODS recalprice FOR MODIFY
      IMPORTING keys FOR ACTION zi_dxtravel~recalprice.

    METHODS rejecttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_dxtravel~rejecttravel RESULT result.
    METHODS validatebookingfee FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_dxtravel~validatebookingfee.

    METHODS validatecurrencycode FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_dxtravel~validatecurrencycode.

    METHODS validatecustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_dxtravel~validatecustomer.

    METHODS validatedates FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_dxtravel~validatedates.

    METHODS validatestatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_dxtravel~validatestatus.
    METHODS caltotalprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_dxtravel~caltotalprice.

    METHODS earlynumbering_cba_booking FOR NUMBERING
      IMPORTING entities FOR CREATE zi_dxtravel\_booking.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE zi_dxtravel.

ENDCLASS.

CLASS lhc_ZI_DXTRAVEL IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
    DATA(lt_entities) = entities.

    DELETE lt_entities WHERE TravelId IS NOT INITIAL.
    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
            nr_range_nr       = '01'
            object            = '/DMO/TRV_M'
            quantity          = CONV #( lines( lt_entities ) )
          IMPORTING
            number            =  DATA(lv_latest_num)
            returncode        =  DATA(lv_code)
            returned_quantity =  DATA(lv_qty)
        ).
      CATCH cx_nr_object_not_found.
      CATCH cx_number_ranges INTO DATA(lo_error).
        LOOP AT lt_entities  INTO DATA(ls_entities).
          APPEND VALUE #( %cid =  ls_entities-%cid
                          %key = ls_entities-%key  )
                 TO failed-zi_dxtravel.
          APPEND VALUE #( %cid =  ls_entities-%cid
                          %key = ls_entities-%key
                          %msg =  lo_error )
                 TO reported-zi_dxtravel .

        ENDLOOP.
        EXIT.
    ENDTRY.

    ASSERT lv_qty = lines( lt_entities ).
    DATA(lv_curr_num)   =  lv_latest_num - lv_qty.

    LOOP AT lt_entities  INTO ls_entities.

      lv_curr_num = lv_curr_num + 1.

      APPEND VALUE #( %cid =  ls_entities-%cid
                      TravelId = lv_curr_num  )
               TO mapped-zi_dxtravel.
    ENDLOOP.
  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.

    READ ENTITIES OF zi_dxtravel IN LOCAL MODE
      ENTITY zi_dxtravel BY \_Booking
      FROM CORRESPONDING #( entities )
      LINK DATA(lt_booking).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entity>)
    GROUP BY <ls_entity>-TravelId.
      DATA(lv_max_booking) = REDUCE #( INIT lv_max = CONV /dmo/booking_id( '0' )
                                 FOR ls_book IN lt_booking USING KEY entity
                                 WHERE ( source-TravelId = <ls_entity>-TravelId )
                                 NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_book-target-BookingId
                                                                       THEN ls_book-target-BookingId
                                                                       ELSE lv_max  ) ).
      lv_max_booking = REDUCE #( INIT lv_max = lv_max_booking
                                  FOR ls_entity IN entities  USING KEY entity
                                  WHERE ( TravelId = <ls_entity>-TravelId )
                                   FOR ls_entity_book IN ls_entity-%target
                                  NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_entity_book-BookingId
                                                                        THEN ls_entity_book-BookingId
                                                                        ELSE lv_max  ) ).
      LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entities>)
                               USING KEY entity
                               WHERE TravelId = <ls_entity>-TravelId.

        LOOP AT <ls_entities>-%target ASSIGNING FIELD-SYMBOL(<ls_booking>).
          APPEND CORRESPONDING #( <ls_booking> ) TO mapped-zi_dxbooking
            ASSIGNING FIELD-SYMBOL(<ls_new_booking>).
          IF <ls_booking>-BookingId IS INITIAL.
            lv_max_booking += 10.
            <ls_new_booking>-BookingId = lv_max_booking.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF zi_dxtravel IN LOCAL MODE
      ENTITY zi_dxtravel
      FIELDS ( TravelId OverallStatus )
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_travel).

    result = VALUE #(  FOR ls_travel IN  lt_travel (
                       %tky = ls_travel-%tky
                       %features-%action-AcceptTravel = COND #( WHEN ls_travel-%data-OverallStatus = 'A'
                                                                 THEN if_abap_behv=>fc-o-disabled
                                                                 ELSE if_abap_behv=>fc-o-enabled )
                       %features-%action-RejectTravel = COND #( WHEN ls_travel-%data-OverallStatus = 'X'
                                                                 THEN if_abap_behv=>fc-o-disabled
                                                                 ELSE if_abap_behv=>fc-o-enabled )
                       %features-%assoc-_Booking      = COND #( WHEN ls_travel-%data-OverallStatus = 'X'
                                                                 THEN if_abap_behv=>fc-o-disabled
                                                                 ELSE if_abap_behv=>fc-o-enabled )
    ) ).

  ENDMETHOD.

  METHOD AcceptTravel.

    MODIFY ENTITIES OF zi_dxtravel IN LOCAL MODE
      ENTITY zi_dxtravel
       UPDATE FIELDS ( OverallStatus )
         WITH VALUE #( FOR ls_keys IN keys ( %tky = ls_keys-%tky
                                             %data-OverallStatus = 'A' ) ).

    READ ENTITIES OF zi_dxtravel IN LOCAL MODE
      ENTITY zi_dxtravel
       ALL FIELDS WITH CORRESPONDING #( keys )
       RESULT DATA(lt_result).

    result = VALUE #( FOR ls_result IN lt_result (  %tky = ls_result-%tky
                                                    %param = ls_result ) ).

  ENDMETHOD.

  METHOD CopyTravel.
    DATA: it_travel       TYPE TABLE FOR CREATE zi_dxtravel,
          it_book_cba     TYPE TABLE FOR CREATE zi_dxtravel\_Booking,
          it_booksupp_cba TYPE TABLE FOR CREATE zi_dxbooking\_Booksupp.

    READ TABLE keys ASSIGNING FIELD-SYMBOL(<ls_keys>) WITH KEY %cid = ' '.
    ASSERT <ls_keys> IS NOT ASSIGNED.

    READ ENTITIES OF zi_dxtravel IN LOCAL MODE
    ENTITY zi_dxtravel
      ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_r_travel)
    FAILED DATA(lt_failed).

    READ ENTITIES OF zi_dxtravel IN LOCAL MODE
    ENTITY zi_dxtravel BY \_Booking
      ALL FIELDS WITH CORRESPONDING #( lt_r_travel )
      RESULT DATA(lt_r_book).

    READ ENTITIES OF zi_dxtravel IN LOCAL MODE
    ENTITY zi_dxbooking BY \_Booksupp
      ALL FIELDS WITH CORRESPONDING #( lt_r_book )
      RESULT DATA(lt_r_booksupp).

    LOOP AT lt_r_travel ASSIGNING FIELD-SYMBOL(<ls_r_travel>).

      APPEND VALUE #( %cid =  keys[ KEY entity  TravelId = <ls_r_travel>-TravelId ]-%cid
                      %data = CORRESPONDING #( <ls_r_travel> EXCEPT TravelId ) )
      TO it_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

      <ls_travel>-BeginDate = cl_abap_context_info=>get_system_date( ).
      <ls_travel>-EndDate = cl_abap_context_info=>get_system_date( ) + 30.
      <ls_travel>-OverallStatus = 'O'.

      APPEND VALUE #( %cid_ref = <ls_travel>-%cid ) TO it_book_cba ASSIGNING FIELD-SYMBOL(<ls_book>).

      LOOP AT lt_r_book ASSIGNING FIELD-SYMBOL(<ls_r_book>)
       USING KEY entity
          WHERE TravelId = <ls_r_travel>-TravelId.

        APPEND VALUE #( %cid = <ls_travel>-%cid && <ls_r_book>-BookingId
                        %data = CORRESPONDING #( <ls_r_book> EXCEPT TravelId  ) )
                  TO <ls_book>-%target ASSIGNING FIELD-SYMBOL(<ls_book_n>).

        <ls_book_n>-BookingStatus  = 'N'.

        APPEND VALUE #( %cid_ref = <ls_book_n>-%cid )
              TO it_booksupp_cba ASSIGNING FIELD-SYMBOL(<ls_booksupp>).

        LOOP AT lt_r_booksupp ASSIGNING FIELD-SYMBOL(<ls_booksupp_r>)
                              USING KEY entity
                              WHERE TravelId = <ls_r_travel>-TravelId
                              AND   BookingId = <ls_r_book>-BookingId.

          APPEND VALUE #( %cid = <ls_travel>-%cid && <ls_r_book>-BookingId && <ls_booksupp_r>-BookingSupplementId
                          %data = CORRESPONDING #( <ls_booksupp_r> EXCEPT TravelId BookingId ) )
                  TO <ls_booksupp>-%target.

        ENDLOOP.
      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF zi_dxtravel IN LOCAL MODE
      ENTITY zi_dxtravel
       CREATE FIELDS ( AgencyId CustomerId BeginDate EndDate BookingFee TotalPrice CurrencyCode OverallStatus Description )
        WITH it_travel

      ENTITY zi_dxtravel CREATE BY \_Booking
        FIELDS  ( BookingId BookingDate CustomerId CarrierId ConnectionId FlightDate FlightPrice CurrencyCode BookingStatus )
        WITH it_book_cba

      ENTITY zi_dxbooking CREATE BY \_Booksupp
         FIELDS ( BookingSupplementId SupplementId Price CurrencyCode )
         WITH it_booksupp_cba
      MAPPED DATA(it_mapped).

    mapped-zi_dxtravel = it_mapped-zi_dxtravel.
  ENDMETHOD.

  METHOD reCalPrice.

    TYPES : BEGIN OF ty_total,
              price TYPE /dmo/total_price,
              curr  TYPE /dmo/currency_code,
            END OF ty_total .
    DATA: lt_total      TYPE TABLE OF ty_total,
          lv_conv_price TYPE ty_total-price.

    READ ENTITIES OF zi_dxtravel IN LOCAL MODE
      ENTITY zi_dxtravel
       FIELDS (  BookingFee CurrencyCode )
         WITH CORRESPONDING #( keys )
        RESULT DATA(lt_travel).

    DELETE lt_travel WHERE CurrencyCode IS INITIAL.

    READ ENTITIES OF zi_dxtravel IN LOCAL MODE
     ENTITY zi_dxtravel BY \_Booking
      FIELDS ( FlightPrice  CurrencyCode )
        WITH CORRESPONDING #( lt_travel )
       RESULT DATA(lt_ba_booking).

    READ ENTITIES OF zi_dxtravel IN LOCAL MODE
      ENTITY zi_dxbooking BY \_Booksupp
        FIELDS ( Price CurrencyCode )
         WITH CORRESPONDING #( lt_ba_booking )
         RESULT DATA(lt_ba_booksuppl).

    LOOP AT lt_travel  ASSIGNING FIELD-SYMBOL(<ls_travel>).
      lt_total =  VALUE #( ( price = <ls_travel>-BookingFee curr = <ls_travel>-CurrencyCode ) ).


      LOOP AT lt_ba_booking ASSIGNING FIELD-SYMBOL(<ls_booking>)
                                  USING KEY entity
                                   WHERE TravelId = <ls_travel>-TravelId
                                   AND CurrencyCode IS NOT INITIAL.

        APPEND VALUE #( price = <ls_booking>-FlightPrice curr = <ls_booking>-CurrencyCode )
        TO lt_total.

        LOOP AT lt_ba_booksuppl ASSIGNING FIELD-SYMBOL(<ls_booksuppl>)
                USING KEY entity
                WHERE TravelId = <ls_booking>-TravelId
                 AND  BookingId = <ls_booking>-BookingId
                  AND CurrencyCode IS NOT INITIAL.
          APPEND VALUE #( price = <ls_booksuppl>-Price curr = <ls_booksuppl>-CurrencyCode )
          TO lt_total.
        ENDLOOP.
      ENDLOOP.

      LOOP AT lt_total ASSIGNING FIELD-SYMBOL(<ls_total>).

        IF <ls_total>-curr = <ls_travel>-CurrencyCode.
          lv_conv_price = <ls_total>-price.
        ELSE.

          /dmo/cl_flight_amdp=>convert_currency(
            EXPORTING
              iv_amount               = <ls_total>-price
              iv_currency_code_source = <ls_total>-curr
              iv_currency_code_target = <ls_travel>-CurrencyCode
              iv_exchange_rate_date   =  cl_abap_context_info=>get_system_date( )
            IMPORTING
              ev_amount               = lv_conv_price
          ).

        ENDIF.

        <ls_travel>-TotalPrice =  <ls_travel>-TotalPrice + lv_conv_price.
      ENDLOOP.

    ENDLOOP.

    MODIFY ENTITIES OF zi_dxtravel IN LOCAL MODE
     ENTITY zi_dxtravel
     UPDATE FIELDS ( TotalPrice )
     WITH CORRESPONDING #( lt_travel ).
  ENDMETHOD.

  METHOD RejectTravel.
    MODIFY ENTITIES OF zi_dxtravel IN LOCAL MODE
       ENTITY zi_dxtravel
        UPDATE FIELDS ( OverallStatus )
          WITH VALUE #( FOR ls_keys IN keys ( %tky = ls_keys-%tky
                                              %data-OverallStatus = 'X' ) ).

    READ ENTITIES OF zi_dxtravel IN LOCAL MODE
      ENTITY zi_dxtravel
       ALL FIELDS WITH CORRESPONDING #( keys )
       RESULT DATA(lt_result).

    result = VALUE #( FOR ls_result IN lt_result (  %tky = ls_result-%tky
                                                    %param = ls_result ) ).
  ENDMETHOD.

  METHOD validateCustomer.

    READ ENTITY  IN LOCAL MODE zi_dxtravel
     FIELDS ( CustomerId )
     WITH CORRESPONDING #( keys )
     RESULT DATA(lt_travel).

    DATA: lt_cust TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.

    lt_cust = CORRESPONDING #( lt_travel DISCARDING DUPLICATES MAPPING customer_id = CustomerId  ).
    DELETE lt_cust WHERE customer_id IS INITIAL.
    SELECT
     FROM /dmo/customer
     FIELDS customer_id
     FOR ALL ENTRIES IN @lt_cust
     WHERE customer_id = @lt_cust-customer_id
     INTO TABLE @DATA(lt_cust_db).
    IF sy-subrc IS INITIAL.

    ENDIF.

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

      IF <ls_travel>-CustomerId IS INITIAL
         OR  NOT line_exists( lt_cust_db[ customer_id = <ls_travel>-CustomerId  ] )   .

        APPEND VALUE #( %tky = <ls_travel>-%tky )
                   TO failed-zi_dxtravel.
        APPEND VALUE #( %tky = <ls_travel>-%tky
                        %msg = NEW /dmo/cm_flight_messages(
                                            textid                = /dmo/cm_flight_messages=>customer_unkown
                                           customer_id           = <ls_travel>-CustomerId
                                severity              = if_abap_behv_message=>severity-error
                                )
                        %element-CustomerId = if_abap_behv=>mk-on

        )
                   TO reported-zi_dxtravel.



      ENDIF.

    ENDLOOP.

  ENDMETHOD.



  METHOD validateBookingFee.
  ENDMETHOD.

  METHOD validateCurrencyCode.
  ENDMETHOD.

  METHOD validateDates.
    READ ENTITIES OF zi_dxtravel IN LOCAL MODE
              ENTITY zi_dxtravel
                FIELDS ( BeginDate EndDate )
                WITH CORRESPONDING #( keys )
              RESULT DATA(lt_travels).

    LOOP AT lt_travels INTO DATA(travel).

      IF travel-EndDate < travel-BeginDate.  "end_date before begin_date

        APPEND VALUE #( %tky = travel-%tky ) TO failed-zi_dxtravel.

        APPEND VALUE #( %tky = travel-%tky
                        %msg = NEW /dmo/cm_flight_messages(
                                   textid     = /dmo/cm_flight_messages=>begin_date_bef_end_date
                                   severity   = if_abap_behv_message=>severity-error
                                   begin_date = travel-BeginDate
                                   end_date   = travel-EndDate
                                   travel_id  = travel-TravelId )
                        %element-BeginDate   = if_abap_behv=>mk-on
                        %element-EndDate     = if_abap_behv=>mk-on
                     ) TO reported-zi_dxtravel.

      ELSEIF travel-BeginDate < cl_abap_context_info=>get_system_date( ).  "begin_date must be in the future

        APPEND VALUE #( %tky        = travel-%tky ) TO failed-zi_dxtravel.

        APPEND VALUE #( %tky = travel-%tky
                        %msg = NEW /dmo/cm_flight_messages(
                                    textid   = /dmo/cm_flight_messages=>begin_date_on_or_bef_sysdate
                                    severity = if_abap_behv_message=>severity-error )
                        %element-BeginDate  = if_abap_behv=>mk-on
                        %element-EndDate    = if_abap_behv=>mk-on
                      ) TO reported-zi_dxtravel.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD validateStatus.
*    READ ENTITIES OF zi_dxtravel IN LOCAL MODE
*        ENTITY zi_dxtravel
*          FIELDS ( OverallStatus )
*          WITH CORRESPONDING #( keys )
*        RESULT DATA(lt_travels).
*
*    LOOP AT lt_travels INTO DATA(ls_travel).
*      CASE ls_travel-OverallStatus.
*        WHEN 'O'.  " Open
*        WHEN 'X'.  " Cancelled
*        WHEN 'A'.  " Accepted
*
*        WHEN OTHERS.
*          APPEND VALUE #( %tky = ls_travel-%tky ) TO failed-zi_dxtravel.
*
*          APPEND VALUE #( %tky = ls_travel-%tky
*                          %msg = NEW /dmo/cm_flight_messages(
*                                     textid = /dmo/cm_flight_messages=>status_invalid
*                                     severity = if_abap_behv_message=>severity-error
*                                     status = ls_travel-OverallStatus )
*                          %element-OverallStatus = if_abap_behv=>mk-on
*                        ) TO reported-zi_dxtravel.
*      ENDCASE.
*    ENDLOOP.
  ENDMETHOD.

  METHOD calTotalPrice.
    MODIFY ENTITIES OF zi_dxtravel  IN LOCAL MODE
      ENTITY zi_dxtravel
      EXECUTE reCalPrice FROM CORRESPONDING #( keys ).
  ENDMETHOD.

ENDCLASS.
