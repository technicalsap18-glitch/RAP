@EndUserText.label: 'Maintain Employee Data Table Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@UI: {
  headerInfo: {
    typeName: 'EmployeeDataTablAll'
  }
}
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZC_DXSM30AUTO_S
  provider contract TRANSACTIONAL_QUERY
  as projection on ZI_DXSM30AUTO_S
{
  @UI.facet: [ {
    id: 'ZI_DXSM30AUTO', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'Employee Data Table', 
    position: 1 , 
    targetElement: '_EmployeeDataTable'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key SingletonID,
  @UI.hidden: true
  LastChangedAtMax,
  @ObjectModel.text.element: [ 'TransportRequestDescription' ]
  @UI.identification: [ {
    position: 1 , 
    type: #WITH_INTENT_BASED_NAVIGATION, 
    semanticObjectAction: 'manage'
  } ]
  @Consumption.semanticObject: 'CustomizingTransport'
  TransportRequestID,
  @UI.hidden: true
  _ABAPTransportRequestText.TransportRequestDescription : localized,
  _EmployeeDataTable : redirected to composition child ZC_DXSM30AUTO
}
