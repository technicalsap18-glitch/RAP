@EndUserText.label: 'Employee Data Table Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZI_DXSM30AUTO_S
  as select from I_Language
    left outer join ZDX_SM30_TBC1 on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_DXSM30AUTO as _EmployeeDataTable
{
  key 1 as SingletonID,
  _EmployeeDataTable,
  max( ZDX_SM30_TBC1.CHANGED_AT ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  _ABAPTransportRequestText
}
where I_Language.Language = $session.system_language
