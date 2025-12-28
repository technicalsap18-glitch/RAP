@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Book Supp View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_DXbooksupp as projection on ZDX_BOOKSUPP
{   
    key TravelId,
    key BookingId,
    key BookingSupplementId,
    SupplementId,
    @ObjectModel.text.element: [ 'SupplementDesc' ]
    _supptxt.Description as SupplementDesc: localized,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    Price,
    CurrencyCode,
    LastChangedAt,
    /* Associations */
    _Travel: redirected to ZC_DXTRAVEL,
    _Booking: redirected to parent ZC_DXBOOKING,
    _supp,
    _supptxt
}
