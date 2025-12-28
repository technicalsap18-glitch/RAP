@EndUserText.label: 'Employee Data Table'
@AccessControl.authorizationCheck: #MANDATORY
define view entity ZI_DXSM30AUTO
  as select from ZDX_SM30_TBC1
  association to parent ZI_DXSM30AUTO_S as _EmployeeDataTablAll on $projection.SingletonID = _EmployeeDataTablAll.SingletonID
{
  key EMPLOYEE_ID as EmployeeId,
  FIRST_NAME as FirstName,
  LAST_NAME as LastName,
  DEPARTMENT as Department,
  JOINING_DATE as JoiningDate,
  IS_ACTIVE as IsActive,
  CHANGED_BY as ChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  CHANGED_AT as ChangedAt,
  1 as SingletonID,
  _EmployeeDataTablAll
}
