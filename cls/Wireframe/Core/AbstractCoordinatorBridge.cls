Class Wireframe.Core.AbstractCoordinatorBridge [ Abstract ]
{

Property Coordinator As Wireframe.Core.AbstractCoordinator [ Private ];

Method %OnNew() As %Status
{
  set ..Coordinator = ..OnSetCoordinator()
  return $$$OK
}

Method OnSetCoordinator() As Wireframe.Core.AbstractCoordinator [ Abstract ]
{
  $$$ThrowStatus($$$ERROR($$$MethodNotImplemented, "OnSetCoordinator"))
}

Method %DispatchMethod(methodName As %String, args...) [ Final ]
{
  return ..Coordinator.SetupRecorder(methodName).Begin(args...)
}

Method GetCoordinator() As Wireframe.Core.AbstractCoordinator
{
  return ..Coordinator
}

}

