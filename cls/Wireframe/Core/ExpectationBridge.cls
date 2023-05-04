Class Wireframe.Core.ExpectationBridge Extends (%RegisteredObject, Wireframe.Core.AbstractCoordinatorBridge)
{

Method OnSetCoordinator() As Wireframe.Core.MockCoordinator
{
  return ##class(Wireframe.Core.MockCoordinator).%New()
}

Method OnBeforeSetupRecorder(consolidator As Wireframe.Core.BridgeConsolidator, methodName As %String)
{
  do consolidator.AssertMethodIsNotStubbed(methodName)
}

}

