Class Wireframe.Core.AbstractBehaviorState [ Abstract ]
{

Property ValueToReturn [ Private ];

Property ExceptionToThrow As %Exception.AbstractException [ Private ];

Property Arguments [ MultiDimensional, Private ];

Property Passthrough As %Boolean [ Private ];

Method %OnNew(valueToReturn, exceptionToThrow As %Exception.AbstractException, passthrough As %Boolean, ByRef args = "") As %Status
{
  set ..ValueToReturn = valueToReturn
  set ..ExceptionToThrow = exceptionToThrow
  set ..Passthrough = passthrough
  merge i%Arguments = args
  
  return $$$OK
}

Method IsPassthrough() As %Boolean
{
  return ..Passthrough
}

Method HasExceptionToThrow() As %Exception.AbstractException
{
  return $isobject(..ExceptionToThrow) && ..ExceptionToThrow.%IsA("%Exception.AbstractException")
}

Method GetArguments(Output args = 0)
{
  merge args = i%Arguments
  set args = $get(i%Arguments, "")
}

Method GetUnwrappedArguments(Output args = 0)
{
  if i%Arguments > 0 {
    for i=1:1:i%Arguments {
      set args(i) = i%Arguments(i).GetArgumentValue()
    }
  
    set args = i%Arguments
  }
}

Method GetValueToReturn()
{
  return ..ValueToReturn
}

Method GetExceptionToThrow()
{
  return ..ExceptionToThrow
}

}

