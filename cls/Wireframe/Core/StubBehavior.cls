Class Wireframe.Core.StubBehavior Extends (%RegisteredObject, Wireframe.Core.AbstractBehavior)
{

Method ThenReturn(returnValues...)
{
  do ..SetValueToReturn(returnValues...)
}

Method ThenThrow(exceptions... As %Exception.AbstractException)
{
  do ..SetExceptionToThrow(exceptions...)
}

Method ThenPassthrough()
{
  do ..SetPassthrough()
}

Method GetState() As Wireframe.Core.StubBehaviorState
{
  merge args = i%Arguments
  
  return ##class(Wireframe.Core.StubBehaviorState).%New(
    ..ValueToReturn, 
    ..ExceptionToThrow, 
    ..Passthrough,
    .args
  )
}

}

