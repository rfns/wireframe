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

Method OnGetNextBehavior(behavior As Wireframe.Core.StubBehavior, methodName As %String, args...) As Wireframe.Core.StubBehaviorState [ Private ]
{
  do ..AssertMethodIsStubbed(methodName, behavior, args...)

  if $isobject(behavior) return behavior.GetState()
  
  return ""
}

Method AssertMethodIsStubbed(methodName As %String, behavior As Wireframe.Core.StubBehavior, args...) [ Private ]
{
  // Must skip setters and getters because they'll be called implicitly by the SUT most of times.
  if $extract(methodName, *-2, *) = "Get" return
  if $extract(methodName, *-2, *) = "Set" return  
  
  set serialArgs = ##class(Wireframe.Core.Helpers).SerializeArguments(.args)

  if '..HasAnyMethodBehavior(methodName) {
    $$$ThrowStatus($$$ERROR($$$GeneralError, $$$FormatText("Call for method '%1' is not stubbed (args: %2)", methodName, serialArgs)))
  }
}

Method HasAnyMethodBehavior(methodName As %String) As %Boolean [ Private ]
{
  return ..Recorders.IsDefined(methodName)
}

}

