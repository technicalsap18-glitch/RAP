@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'booking projection view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_DXBOOKING_U
  as projection on ZI_DXBOOKING_U
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
      /* Associations */
      _Connection,
      _Customer,
      _Carrier,
      _Travel   : redirected to parent ZC_DXTRAVEL_U
}
