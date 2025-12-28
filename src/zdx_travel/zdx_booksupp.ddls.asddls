@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Supply Interface'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZDX_BOOKSUPP
  as select from /dmo/booksuppl_m
  association        to parent ZI_DXBOOKING   as _Booking on  $projection.TravelId  = _Booking.TravelId
                                                          and $projection.BookingId = _Booking.BookingId                                 
  association [1..1] to  ZI_DXTRAVEL          as _Travel  on  $projection.TravelId = _Travel.TravelId
  association [1..1] to /DMO/I_Supplement     as _supp    on  $projection.SupplementId = _supp.SupplementID
  association [1..*] to /DMO/I_SupplementText as _supptxt on  $projection.SupplementId = _supptxt.SupplementID

{
  key travel_id             as TravelId,
  key booking_id            as BookingId,
  key booking_supplement_id as BookingSupplementId,
      supplement_id         as SupplementId,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price                 as Price,
      currency_code         as CurrencyCode,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at       as LastChangedAt,
      _Travel,
      _Booking,
      _supp,
      _supptxt
}
