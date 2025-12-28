@EndUserText.label: 'Copy Employee Data Table'
define abstract entity ZD_CopySM30AUTO
{
  @EndUserText.label: 'New MedewerkerId'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: EmployeeId' )
  EmployeeId : ZEMPLOYEE_ID;
}
