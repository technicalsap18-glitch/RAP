@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'booking projection view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_DXAPPROVAL_BOOK as projection on ZI_DXBOOKING
{
    key TravelId,
  key BookingId,
      BookingDate,
      CustomerId,
      _Customer.LastName        as CustomerName,
      CarrierId,
      _Carrier.Name             as CarrierName,
      ConnectionId,
      _Connection._Airline.Name as ConnectionName,
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      CurrencyCode,
      BookingStatus,
      LastChangedAt,
      /* Associations */
      _Booksupp,
      _Connection,
      _Customer,
      _Status,
      _Carrier,
    _Travel   : redirected to parent ZC_DXAPPROVAL_TRAVEL
}
