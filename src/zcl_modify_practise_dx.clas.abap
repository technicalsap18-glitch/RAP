CLASS zcl_modify_practise_dx DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_modify_practise_dx IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

*  -----create single entity
*    MODIFY ENTITY zi_dxtravel
*        CREATE FROM VALUE #(  (  %cid = 'cid1'
*                                 BeginDate = '20240505'
*                                 %control-BeginDate = if_abap_behv=>mk-on )  )
*        CREATE BY \_Booking
*        FROM VALUE #( ( %cid_ref = 'cid1'
*                         %target = VALUE #(  %cid = 'cid11'
*                                              BookingDate = '20240505'
*                                              %control-BookingDate = if_abap_behv=>mk-on )  ) )
*   FAILED DATA(lt_failed)
*   MAPPED DATA(lt_mapp)
*   REPORTED DATA(lt_report).


*--- create with long form
*    MODIFY ENTITIES OF zi_dxtravel
*      ENTITY zi_dxtravel
*       CREATE FIELDS ( BeginDate  )
*        WITH VALUE #( (  %cid = 'cid1'
*                                  BeginDate = '20240505'
*                                   ) )
*                                   FAILED DATA(lt_failed)
*    MAPPED DATA(lt_mapp)
*    REPORTED DATA(lt_report) .
*    COMMIT ENTITIES.
*
*    if lt_failed Is INITIAL.
*    data(lt_travel) = lt_mapp-zi_dxtravel.
*    LOOP AT lt_mapp-zi_dxtravel INTO DATA(ls_data).
*      READ ENTITY zi_dxtravel ALL FIELDS WITH VALUE #( (   %tky-TravelId = ls_data-TravelId ) ) RESULT DATA(lt_result).
*      out->write( lt_result ).
*    ENDLOOP.
*    ENDIF.
*---- update
    MODIFY ENTITY zi_dxtravel
        UPDATE FIELDS ( BeginDate  )
        WITH VALUE #( ( TravelId = '00004151'  BeginDate = '20240510' ) )
        FAILED DATA(lt_failed)
     MAPPED DATA(lt_mapp)
     REPORTED DATA(lt_report).
     COMMIT ENTITIES.
    IF lt_failed IS INITIAL..
        READ ENTITY zi_dxtravel ALL FIELDS WITH VALUE #( (   %tky-TravelId = '00004151' ) ) RESULT DATA(lt_result).
        out->write( lt_result ).
    ENDIF.
*--- delete
    MODIFY ENTity zi_dxtravel
      DELETE FROM VALUE #( ( TravelId = '0000004151' ) ) .
      COMMIT ENTITIES.

  ENDMETHOD.

ENDCLASS.
