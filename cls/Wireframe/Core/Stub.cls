Class Wireframe.Core.Stub Extends (%RegisteredObject, Wireframe.Core.AbstractTestDouble)
{

Method OnSetBridge() As Wireframe.Core.AbstractCoordinatorBridge [ Private ]
{
  return ##class(Wireframe.Core.BehaviorBridge).%New()
}

}

