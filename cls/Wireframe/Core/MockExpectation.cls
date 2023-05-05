Class Wireframe.Core.MockExpectation Extends (%RegisteredObject, Wireframe.Core.AbstractBehavior)
{

Property Times As %Integer [ InitialExpression = 1, Private ];

Property Comparator As %String [ InitialExpression = "=", Private ];

Property ExpectedCallIndex As %String [ Private ];

Method Times(n As %Integer) [ Private ]
{
  set ..Times = 1
  set ..Comparator = "="
  return $this
}

Method AndReturn(returnValues...)
{
  do ..SetValueToReturn(returnValues...)
}

Method AndThrow(exceptions... As %Exception.AbstractException)
{
  
  do ..SetExceptionToThrow(exceptions...)
}

Method AtLeast(n As %Integer)
{
  set ..Times = n
  set ..Comparator = ">="
  
  return $this
}

Method AtMost(n As %Integer)
{
  set ..Times = n
  set ..Comparator = "<="
  
  return $this
}

Method Exactly(n As %Integer)
{
  return ..Times(n)
}

Method GetExpectedTimes() As %String
{
  return $$$FormatText("%1 %2", ..Comparator, ..Times)
}

Method GetState() As Wireframe.Core.MockExpectationState
{
  merge args = i%Arguments
  
  return ##class(Wireframe.Core.MockExpectationState).%New(
    ..ValueToReturn, 
    ..ExceptionToThrow, 
    ..Passthrough,     
    .args
  )
}

Method SetExpectedCallIndex(expectedCallIndex As %Integer)
{
  set ..ExpectedCallIndex = expectedCallIndex
}

}

