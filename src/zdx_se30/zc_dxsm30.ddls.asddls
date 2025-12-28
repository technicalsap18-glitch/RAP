@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZC_EMP_S'
//@Metadata.ignorePropagatedAnnotations: true
@UI: { headerInfo: { typeName:       'Employee',
                     typeNamePlural: 'Employees',
                     title:          { type: #STANDARD,
                                       label: 'Employee',
                                       value: 'EmployeeId' } } }
define view entity ZC_DXSM30
  as projection on ZI_DXSM30
{
      @UI.facet: [{ type: #IDENTIFICATION_REFERENCE }]

      @UI.lineItem: [{ position: 10 }]
      @UI.identification: [{ position: 10 }]
            @EndUserText.label : 'Employee ID'
  key EmployeeId,
      EmpSingleton,
      @UI.lineItem: [{ position: 20 }]
      @UI.identification: [{ position: 20 }]
      @EndUserText.label : 'First Name'
      FirstName,
      @UI.lineItem: [{ position: 30 }]
      @UI.identification: [{ position: 30 }]
      @EndUserText.label : 'Last Name'
      LastName,
      @UI.lineItem: [{ position: 40 }]
      @UI.identification: [{ position: 40 }]
      @EndUserText.label : 'Department'
      Department,
      @UI.lineItem: [{ position: 50 }]
      @UI.identification: [{ position: 50 }]
      @EndUserText.label : 'Joining Date'
      JoiningDate,
      @UI.lineItem: [{ position: 60 }]
      @UI.identification: [{ position: 60 }]
      @EndUserText.label : 'Active Employee'
      IsActive,
      @Semantics.user.lastChangedBy: true
      ChangedBy,
      //etag
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,
      //total etag
      @Semantics.systemDateTime.lastChangedAt: true
      ChangedAt,
      /* Associations */
      _sEmp : redirected to parent ZC_SM30SINGLETON_S
}
