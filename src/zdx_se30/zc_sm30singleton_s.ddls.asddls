@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZC_EMPSINGLETON_S'
@Metadata.ignorePropagatedAnnotations: true
@UI: { headerInfo: { typeName: 'Manage Employee',
                     typeNamePlural: 'Employee Singleton',
                     title: { type: #STANDARD, value: 'EmpSingleton' } } }
define root view entity ZC_SM30SINGLETON_S
  provider contract transactional_query
  as projection on Zi_SM30Singleton_S
{
      @UI.facet: [

       {
         purpose:  #STANDARD,
         type:     #LINEITEM_REFERENCE,
         label:    'Employee Multi Inline Edit',
         position: 10,
         targetElement: '_emp'
       }
       ]

      @UI.lineItem: [{ position: 10 }]
  key EmpSingleton,
      maxChangedat,
  
      /* Associations */
      _emp : redirected to composition child ZC_DXSM30
}
