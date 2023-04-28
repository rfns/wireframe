Class Wireframe.ArgumentTypes.AnyOf Extends (%RegisteredObject, Wireframe.Core.MatchableArgument)
{

Property ExpectedType As %String [ Private ];

Method %OnNew(expectedType As %String) As %Status
{
  set ..ExpectedType = expectedType
  return $$$OK
}

Method Match(input) As %Boolean
{
  if $isobject(input) {
    return input.%IsA(..ExpectedType)
  }
      
  if ##class(%Dictionary.CompiledClass).%ExistsId(..ExpectedType_"||IsValid") {
    return $classmethod(..ExpectedType, "IsValid", input)
  }
  
  return 0
}

}

