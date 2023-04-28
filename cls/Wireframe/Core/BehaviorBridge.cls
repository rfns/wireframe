Class Wireframe.Core.BehaviorBridge Extends (%RegisteredObject, Wireframe.Core.AbstractCoordinatorBridge)
{

Method OnSetCoordinator() As Wireframe.Core.StubCoordinator
{
  return ##class(Wireframe.Core.StubCoordinator).%New()
}

}

