Class Wireframe.ArgumentTypes.Is Extends (%RegisteredObject, Wireframe.Core.MatchableArgument)
{

Property ExpectedValue As %String [ Private ];

Method %OnNew(value) As %Status
{
  set ..ExpectedValue = value
  return $$$OK
}

Method Match(input) As %Boolean
{
  set value = input
  set expectedValue = ..ExpectedValue

  return (value = expectedValue)
}

}

