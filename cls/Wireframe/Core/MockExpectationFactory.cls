Class Wireframe.Core.MockExpectationFactory Extends (%RegisteredObject, Wireframe.Core.AbstractBehaviorFactory)
{

Method Create(recorder As Wireframe.Core.BehaviorRecorder) As Wireframe.Core.MockExpectation
{
  return ##class(Wireframe.Core.MockExpectation).%New(recorder)
}

}

