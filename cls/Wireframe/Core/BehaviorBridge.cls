Class Wireframe.Core.BehaviorBridge Extends (%RegisteredObject, Wireframe.Core.AbstractCoordinatorBridge)
{

Method OnSetCoordinator() As Wireframe.Core.StubCoordinator
{
  return ##class(Wireframe.Core.StubCoordinator).%New()
}

Method OnBeforeSetupRecorder(consolidator As Wireframe.Core.BridgeConsolidator, methodName As %String)
{
  do consolidator.AssertMethodIsNotMocked(methodName)
}

}

