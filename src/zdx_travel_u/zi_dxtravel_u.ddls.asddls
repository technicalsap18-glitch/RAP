@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Interface view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_DXTRAVEL_U
  as select from /dmo/travel
  composition[0..*] of ZI_DXBOOKING_U as _Booking
  association [0..1] to /dmo/agency              as _Agency   on $projection.AgencyId = _Agency.agency_id
  association [0..1] to /dmo/customer            as _Customer on $projection.CustomerId = _Customer.customer_id
  association [1..1] to I_Currency               as _Currency on $projection.CurrencyCode = _Currency.Currency
  association [0..1] to /DMO/I_Overall_Status_VH as _Status   on $projection.OverallStatus = _Status.OverallStatus
{
  key travel_id       as TravelId,
      agency_id       as AgencyId,
      customer_id     as CustomerId,
      begin_date      as BeginDate,
      end_date        as EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      booking_fee     as BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_price     as TotalPrice,
      currency_code   as CurrencyCode,
      description     as Description,
      status  as OverallStatus,
      @Semantics.user.createdBy: true
      createdby      as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      createdat      as CreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      lastchangedby as LastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      lastchangedat as LastChangedAt,
      _Agency,
      _Customer,
      _Currency,
      _Status,
     _Booking
}
