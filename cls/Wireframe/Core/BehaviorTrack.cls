Class Wireframe.Core.BehaviorTrack Extends %RegisteredObject
{

Property Coordinator As Wireframe.Core.StubCoordinator [ Private ];

Method %OnNew(coordinator As Wireframe.Core.StubCoordinator) As %Status
{
  set ..Coordinator = coordinator
  return $$$OK
}

Method %DispatchMethod(methodName As %String, args...)
{
  return ..Coordinator.SetupRecorder(methodName).Begin(args...)
}

}

