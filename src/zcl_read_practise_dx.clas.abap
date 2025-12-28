CLASS zcl_read_practise_dx DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_read_practise_dx IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    "--------- single entity
*    READ ENTITY zi_dxtravel
* " FIELDS ( AgencyId BeginDate CreatedAt )
* BY \_Booking
*   ALL FIELDS
*    WITH VALUE #( ( %key-TravelId = '0000000003' )
*    ( %key-TravelId = '0000000004' )  )
*    RESULT DATA(lt_result)
*    FAILED DATA(lt_failed).
*    IF lt_failed IS NOT INITIAL.
*      out->write( 'Report Failed' ).
*    ELSE.
*      out->write( lt_result ).
*    ENDIF.
    "---------Multiple Entity
*    READ ENTITIES OF zi_dxtravel
*       ENTITY zi_dxtravel
*       ALL FIELDS WITH VALUE #( ( %key-TravelId = '0000000003' )
*         )
*       RESULT DATA(lt_r_travel)
*
*       ENTITY zi_dxbooking
*       ALL FIELDS WITH VALUE #( (  %key-TravelId = '0000000007'
*                                   %key-BookingId = '0010' )  )
*       RESULT DATA(lt_r_book)
*
*       FAILED DATA(lt_failed_sort).
*    IF lt_failed_sort IS NOT INITIAL.
*      out->write( 'Read Failed' ).
*    ELSE.
*      out->write( lt_r_travel ).
*      out->write( lt_r_book ).
*    ENDIF.
*  ---------------Dynamic read
    DATA: it_optab    TYPE abp_behv_retrievals_tab,
          it_travel   TYPE TABLE FOR READ IMPORT zi_dxtravel,
          it_r_travel TYPE TABLE FOR READ RESULT zi_dxtravel,
          it_book     TYPE TABLE FOR READ IMPORT zi_dxbooking,
          it_r_book   TYPE TABLE FOR READ RESULT zi_dxbooking.

    it_travel = VALUE #( ( %key-TravelId = '0000000003'
                           %control = VALUE #( AgencyId = if_abap_behv=>mk-on
                                               CustomerId = if_abap_behv=>mk-on
                                               BeginDate = if_abap_behv=>mk-on
                                             )
    ) ).
    it_book = VALUE #( ( %key-TravelId = '0000000003'
                           %control = VALUE #( BookingId = if_abap_behv=>mk-on
                                               BookingStatus = if_abap_behv=>mk-on
                                               BookingDate = if_abap_behv=>mk-on
                                             )
    ) ).
    it_optab = VALUE #( ( op = 'R'
                         entity_name = 'ZI_DXTRAVEL'
                         instances = REF #( it_travel )
                         results = REF #( it_r_travel )
    )
                        ( op = if_abap_behv=>op-r-read_ba
                         entity_name = 'ZI_DXTRAVEL'
                         sub_name = '_BOOKING'
                         instances = REF #( it_book )
                         results = REF #( it_r_book )
    ) ).
    READ ENTITIES OPERATIONS it_optab FAILED FINAL(lt_failed_dy).
    IF lt_failed_dy IS NOT INITIAL.
      out->write( 'Read Failed' ).
    ELSE.
      out->write( it_r_travel ).
      out->write( it_r_book ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
