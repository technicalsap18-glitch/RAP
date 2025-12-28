CLASS lhc_zdx_booksupp DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateCurrencyCode FOR VALIDATE ON SAVE
      IMPORTING keys FOR zdx_booksupp~validateCurrencyCode.

    METHODS validatePrice FOR VALIDATE ON SAVE
      IMPORTING keys FOR zdx_booksupp~validatePrice.

    METHODS validateSupplement FOR VALIDATE ON SAVE
      IMPORTING keys FOR zdx_booksupp~validateSupplement.
    METHODS calTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zdx_booksupp~calTotalPrice.

ENDCLASS.

CLASS lhc_zdx_booksupp IMPLEMENTATION.

  METHOD validateCurrencyCode.
  ENDMETHOD.

  METHOD validatePrice.
  ENDMETHOD.

  METHOD validateSupplement.
  ENDMETHOD.

  METHOD calTotalPrice.
    DATA: it_travel TYPE STANDARD TABLE OF zi_dxtravel WITH UNIQUE HASHED KEY key COMPONENTS TravelId.

    it_travel =  CORRESPONDING #(  keys DISCARDING DUPLICATES MAPPING TravelId = TravelId ).
    MODIFY ENTITIES OF zi_dxtravel IN LOCAL MODE
     ENTITY zi_dxtravel
     EXECUTE  reCalPrice
     FROM CORRESPONDING #( it_travel ).
  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
