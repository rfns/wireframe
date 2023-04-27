Class Wireframe.Core.Behavior Extends %RegisteredObject
{

Property Recorder As Wireframe.Core.BehaviorRecorder [ Private ];

Property ValueToReturn [ Private ];

Property ExceptionToThrow As %Exception.AbstractException [ Private ];

Property Arguments [ MultiDimensional, Private ];

Property Passthrough As %Boolean [ Private ];

Method %OnNew(recorder As Wireframe.Core.Stub) As %Status
{
  set ..Recorder = recorder
  return $$$OK
}

Method ThenReturn(returnValues...)
{
  set ..ValueToReturn = returnValues(1)

  if returnValues > 1 {
    for i=2:1:returnValues {
      do ..Recorder.CloneCurrentBehavior().ThenReturn(returnValues(i))
    }
    quit
  }
}

Method ThenThrow(exceptions... As %Exception.AbstractException)
{
  set ..ExceptionToThrow = exceptions(1)

  if exceptions > 1 {
    for i=2:1:exceptions {
      do ..Recorder.CloneCurrentBehavior().ThenThrow(exceptions(i))
    }
  }
}

Method ThenPassthrough()
{
  set ..Passthrough = 1
}

Method IsPassthrough() As %Boolean
{
  return ..Passthrough
}

Method ReceiveArguments(arguments...) As Wireframe.Core.Behavior
{
  do ..WrapInArgumentType(arguments...)
  return $this
}

Method HasExceptionToThrow() As %Exception.AbstractException
{
  return $isobject(..ExceptionToThrow) && ..ExceptionToThrow.%IsA("%Exception.AbstractException")
}

Method GetArguments(Output args = 0)
{
  merge args = i%Arguments
  set args = $get(i%Arguments, 0)
}

Method GetValueToReturn()
{
  return ..ValueToReturn
}

Method GetExceptionToThrow()
{
  return ..ExceptionToThrow
}

Method WrapInArgumentType(values...)
{
  for i=1:1:values {
    set value = values(i)
    if $isobject(value) && value.%Extends("Wireframe.Core.MatchableArgument") {
      set i%Arguments(i) = value
    } else {
      set i%Arguments(i) = ##class(Wireframe.ArgumentTypes.Is).%New(value)
    }
  }

  set i%Arguments = i
}

}

