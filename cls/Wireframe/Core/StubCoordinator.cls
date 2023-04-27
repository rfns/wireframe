Class Wireframe.Core.StubCoordinator Extends %RegisteredObject
{

Property Stub As Wireframe.Core.Stub [ Private ];

Property Recorders As array Of Wireframe.Core.BehaviorRecorder [ Private ];

Method %OnNew(stub As Wireframe.Core.Stub) As %Status
{
  set ..Stub = stub
  return $$$OK
}

Method SetRecorder(recorder As Wireframe.Core.BehaviorRecorder)
{
  set name = recorder.GetMethodName()

  if '..Recorders.IsDefined(name) {
    do ..Recorders.SetAt(recorder, name)
  }
}

Method SetupRecorder(methodName As %String) As Wireframe.Core.BehaviorRecorder
{

  set recorder = ..Recorders.GetAt(methodName)
  if $isobject(recorder) return recorder

  set recorder = ##class(Wireframe.Core.BehaviorRecorder).%New($this)
  do recorder.SetMethodName(methodName)

  do ..SetRecorder(recorder)

  return recorder
}

Method GetNextBehavior(methodName As %String, args...)
{
  set recorder = ..Recorders.GetAt(methodName)
  set behavior = recorder.GetNextBehavior(args...)

  do ..AssertMethodIsStubbed(methodName, behavior, args...)

  return behavior
}

Method AssertMethodIsStubbed(methodName As %String, behavior As Wireframe.Core.Behavior, args...) [ Private ]
{
  set serialArgs = ##class(Wireframe.Core.Helpers).SerializeArguments(.args)

  if '$isobject(behavior) {
    $$$ThrowStatus($$$ERROR($$$GeneralError, $$$FormatText("Call for method '%1' is not stubbed (args: %2)", methodName, serialArgs)))
  }
}

}

