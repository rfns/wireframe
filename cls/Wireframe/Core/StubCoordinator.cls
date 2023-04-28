Class Wireframe.Core.StubCoordinator Extends (%RegisteredObject, Wireframe.Core.AbstractCoordinator)
{

Method OnSetupRecorder(methodName As %String) As Wireframe.Core.BehaviorRecorder [ Private ]
{
 
  set behaviorFactory = ##class(Wireframe.Core.StubBehaviorFactory).%New()

  set recorder = ##class(Wireframe.Core.BehaviorRecorder).%New(
    $this,
    behaviorFactory
  )  

  return recorder
}

Method OnGetNextBehavior(behavior As Wireframe.Core.StubBehavior, methodName As %String, args...) As Wireframe.Core.StubBehavior [ Private ]
{
  do ..AssertMethodIsStubbed(methodName, behavior, args...)

  return behavior
}

Method AssertMethodIsStubbed(methodName As %String, behavior As Wireframe.Core.StubBehavior, args...) [ Private ]
{
  set serialArgs = ##class(Wireframe.Core.Helpers).SerializeArguments(.args)

  if '$isobject(behavior) {
    $$$ThrowStatus($$$ERROR($$$GeneralError, $$$FormatText("Call for method '%1' is not stubbed (args: %2)", methodName, serialArgs)))
  }
}

}

