CLASS lhc_ZI_DXBOOKING__D DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_dxbooking__d~calculateTotalPrice.

    METHODS setBookingDate FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_dxbooking__d~setBookingDate.

    METHODS setBookingNumber FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_dxbooking__d~setBookingNumber.
    METHODS validateCustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZI_DXBOOKING__D~validateCustomer.

ENDCLASS.

CLASS lhc_ZI_DXBOOKING__D IMPLEMENTATION.

  METHOD calculateTotalPrice.
    " Read all parent UUIDs
    READ ENTITIES OF ZI_DXTRAVEL_D IN LOCAL MODE
         ENTITY zi_dxbooking__d BY \_Travel
         FIELDS ( TravelUUID  )
         WITH CORRESPONDING #( keys )
         RESULT DATA(travels).

    " Trigger Re-Calculation on Root Node
    MODIFY ENTITIES OF ZI_DXTRAVEL_D IN LOCAL MODE
           ENTITY ZI_DXTRAVEL_D
           EXECUTE reCalcTotalPrice
           FROM CORRESPONDING #( travels ).
  ENDMETHOD.

  METHOD setBookingDate.
    READ ENTITIES OF ZI_DXTRAVEL_D IN LOCAL MODE
         ENTITY zi_dxbooking__d
         FIELDS ( BookingDate )
         WITH CORRESPONDING #( keys )
         RESULT DATA(bookings).

    DELETE bookings WHERE BookingDate IS NOT INITIAL.
    IF bookings IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT bookings ASSIGNING FIELD-SYMBOL(<booking>).
      <booking>-BookingDate = cl_abap_context_info=>get_system_date( ).
    ENDLOOP.

    MODIFY ENTITIES OF ZI_DXTRAVEL_D IN LOCAL MODE
           ENTITY zi_dxbooking__d
           UPDATE FIELDS ( BookingDate )
           WITH CORRESPONDING #( bookings ).
  ENDMETHOD.

  METHOD setBookingNumber.
    DATA max_bookingid   TYPE /dmo/booking_id.
    DATA bookings_update TYPE TABLE FOR UPDATE ZI_DXTRAVEL_D\\zi_dxbooking__d.

    " Read all travels for the requested bookings
    " If multiple bookings of the same travel are requested, the travel is returned only once.
    READ ENTITIES OF ZI_DXTRAVEL_D IN LOCAL MODE
         ENTITY zi_dxbooking__d BY \_Travel
         FIELDS ( TravelUUID )
         WITH CORRESPONDING #( keys )
         RESULT DATA(travels).

    " Process all affected travels. Read respective bookings for one travel
    LOOP AT travels INTO DATA(travel).
      READ ENTITIES OF ZI_DXTRAVEL_D IN LOCAL MODE
           ENTITY ZI_DXTRAVEL_D BY \_Booking
           FIELDS ( BookingID )
           WITH VALUE #( ( %tky = travel-%tky ) )
           RESULT DATA(bookings).

      " find max used bookingID in all bookings of this travel
      max_bookingid = '0000'.
      LOOP AT bookings INTO DATA(booking).
        IF booking-BookingID > max_bookingid.
          max_bookingid = booking-BookingID.
        ENDIF.
      ENDLOOP.

      " Provide a booking ID for all bookings of this travel that have none.
      LOOP AT bookings INTO booking WHERE BookingID IS INITIAL.
        max_bookingid += 1.
        APPEND VALUE #( %tky      = booking-%tky
                        BookingID = max_bookingid )
               TO bookings_update.

      ENDLOOP.
    ENDLOOP.

    " Provide a booking ID for all bookings that have none.
    MODIFY ENTITIES OF ZI_DXTRAVEL_D IN LOCAL MODE
           ENTITY zi_dxbooking__d
           UPDATE FIELDS ( BookingID )
           WITH bookings_update.
  ENDMETHOD.

  METHOD validateCustomer.
      READ ENTITIES OF zi_dxtravel_d IN LOCAL MODE
         ENTITY zi_dxbooking__d
         FIELDS ( CustomerID )
         WITH CORRESPONDING #( keys )
         RESULT DATA(bookings).

    READ ENTITIES OF zi_dxtravel_d IN LOCAL MODE
         ENTITY zi_dxbooking__d BY \_Travel
         FROM CORRESPONDING #( bookings )
         LINK DATA(travel_booking_links).

    DATA customers TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.

    " Optimization of DB select: extract distinct non-initial customer IDs
    customers = CORRESPONDING #( bookings DISCARDING DUPLICATES MAPPING customer_id = CustomerID EXCEPT * ).
    DELETE customers WHERE customer_id IS INITIAL.

    IF customers IS NOT INITIAL.
      " Check if customer ID exists
      SELECT FROM /dmo/customer
        FIELDS customer_id
        FOR ALL ENTRIES IN @customers
        WHERE customer_id = @customers-customer_id
        INTO TABLE @DATA(valid_customers).
    ENDIF.

    " Raise message for non existing customer id
    LOOP AT bookings INTO DATA(booking).
      APPEND VALUE #( %tky        = booking-%tky
                      %state_area = 'VALIDATE_CUSTOMER' ) TO reported-zi_dxbooking__d.

      IF booking-CustomerID IS INITIAL.
        APPEND VALUE #( %tky = booking-%tky ) TO failed-zi_dxbooking__d.

        APPEND VALUE #(
            %tky                = booking-%tky
            %state_area         = 'VALIDATE_CUSTOMER'
            %msg                = NEW /dmo/cm_flight_messages( textid   = /dmo/cm_flight_messages=>enter_customer_id
                                                               severity = if_abap_behv_message=>severity-error )
            %path               = VALUE #( zi_dxtravel_d-%tky = travel_booking_links[
                                                                  KEY id
                                                                  source-%tky = booking-%tky ]-target-%tky )
            %element-CustomerID = if_abap_behv=>mk-on )
               TO reported-zi_dxbooking__d.

      ELSEIF booking-CustomerID IS NOT INITIAL AND NOT line_exists( valid_customers[
                                                                        customer_id = booking-CustomerID ] ).
        APPEND VALUE #( %tky = booking-%tky ) TO failed-zi_dxbooking__d.

        APPEND VALUE #(
            %tky                = booking-%tky
            %state_area         = 'VALIDATE_CUSTOMER'
            %msg                = NEW /dmo/cm_flight_messages( textid      = /dmo/cm_flight_messages=>customer_unkown
                                                               customer_id = booking-customerId
                                                               severity    = if_abap_behv_message=>severity-error )
            %path               = VALUE #(
                zi_dxtravel_d-%tky = travel_booking_links[ KEY id
                                                         source-%tky = booking-%tky ]-target-%tky )
            %element-CustomerID = if_abap_behv=>mk-on )
               TO reported-zi_dxbooking__d.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
