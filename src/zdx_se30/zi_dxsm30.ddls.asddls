@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'interface view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DXSM30 as select from zdx_sm30_t
association to parent Zi_SM30Singleton_S as _sEmp on $projection.EmpSingleton = _sEmp.EmpSingleton
{
    key employee_id as EmployeeId,
      1                     as EmpSingleton,
    first_name as FirstName,
    last_name as LastName,
    department as Department,
    joining_date as JoiningDate,
    is_active as IsActive,
      @Semantics.user.lastChangedBy: true
      changed_by            as ChangedBy,
      //etag
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      //total etag
      @Semantics.systemDateTime.lastChangedAt: true
      changed_at            as ChangedAt,
      _sEmp
}
