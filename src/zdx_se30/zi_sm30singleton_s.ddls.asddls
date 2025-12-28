@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'interface view - parent'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity Zi_SM30Singleton_S as select from I_Language
left outer join zemployee_ram as zemp on 1 = 1
composition[0..*] of ZI_DXSM30 as _emp
{
    key 1 as EmpSingleton,
    max(zemp.changed_at) as maxChangedat,
    _emp
}
where I_Language.Language  = $session.system_language
