Class Wireframe.Core.AbstractCoordinatorBridge [ Abstract ]
{

Property Consolidator As Wireframe.Core.BridgeConsolidator [ Private ];

Property Coordinator As Wireframe.Core.AbstractCoordinator [ Private ];

Method %OnNew() As %Status
{
  set ..Coordinator = ..OnSetCoordinator()
  return $$$OK
}

Method SetConsolidator(consolidator As Wireframe.Core.BridgeConsolidator)
{
  set ..Consolidator = consolidator
}

Method OnSetCoordinator() As Wireframe.Core.AbstractCoordinator [ Abstract ]
{
  $$$ThrowStatus($$$ERROR($$$MethodNotImplemented, "OnSetCoordinator"))
}

Method %DispatchMethod(methodName As %String, args...) [ Final ]
{
  do ..OnBeforeSetupRecorder(..Consolidator, methodName)
  return ..Coordinator.SetupRecorder(methodName).Begin(args...)
}

Method GetCoordinator() As Wireframe.Core.AbstractCoordinator
{
  return ..Coordinator
}

Method OnBeforeSetupRecorder(consolidator As Wireframe.Core.BridgeConsolidator, methodName As %String)
{
  $$$ThrowStatus($$$ERROR($$$MethodNotImplemented, "OnBeforeSetupRecorder"))
}

}

