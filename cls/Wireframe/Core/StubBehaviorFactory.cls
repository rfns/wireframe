Class Wireframe.Core.StubBehaviorFactory Extends (%RegisteredObject, Wireframe.Core.AbstractBehaviorFactory)
{

Method Create(recorder As Wireframe.Core.BehaviorRecorder) As Wireframe.Core.StubBehavior
{
  return ##class(Wireframe.Core.StubBehavior).%New(recorder)
}

}

