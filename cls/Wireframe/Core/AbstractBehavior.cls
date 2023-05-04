Class Wireframe.Core.AbstractBehavior [ Abstract ]
{

Property Recorder As Wireframe.Core.BehaviorRecorder [ Private ];

Property ValueToReturn [ Private ];

Property ExceptionToThrow As %Exception.AbstractException [ Private ];

Property Arguments [ MultiDimensional, Private ];

Property Passthrough As %Boolean [ Private ];

Method %OnNew(recorder As Wireframe.Core.BehaviorRecorder)
{
  set ..Recorder = recorder
  return $$$OK
}

Method GetMethodName() As %String
{
  return ..Recorder.GetMethodName()
}

Method GetState() As Wireframe.Core.BehaviorState
{
  merge args = i%Arguments
  
  return ##class(Wireframe.Core.BehaviorState).%New(
    ..ValueToReturn, 
    ..ExceptionToThrow, 
    ..Passthrough,
    .args 
  )
}

Method SetValueToReturn(returnValues...) [ Final ]
{
  set ..ValueToReturn = returnValues(1)

  if returnValues > 1 {
    for i=2:1:returnValues {
      do ..Recorder.CloneCurrentBehavior().ThenReturn(returnValues(i))
    }
    quit
  }
}

Method SetExceptionToThrow(exceptions... As %Exception.AbstractException) [ Final ]
{
  set ..ExceptionToThrow = exceptions(1)

  if exceptions > 1 {
    for i=2:1:exceptions {
      do ..Recorder.CloneCurrentBehavior().ThenThrow(exceptions(i))
    }
  }
}

Method SetPassthrough()
{
  set ..Passthrough = 1
}

Method ReceiveArguments(arguments...) As Wireframe.Core.StubBehavior [ Final ]
{
  do ..WrapInArgumentType(arguments...)
  return $this
}

Method WrapInArgumentType(values...) [ Private ]
{
  set values = $get(values, "")
  
  if values = "" {
    return    
  }
  
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

