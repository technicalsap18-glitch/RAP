@EndUserText.label: 'Maintain Employee Data Table'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZC_DXSM30AUTO
  as projection on ZI_DXSM30AUTO
{
  key EmployeeId,
  FirstName,
  LastName,
  Department,
  JoiningDate,
  IsActive,
  ChangedBy,
  @Consumption.hidden: true
  LocalLastChangedAt,
  ChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _EmployeeDataTablAll : redirected to parent ZC_DXSM30AUTO_S
}
