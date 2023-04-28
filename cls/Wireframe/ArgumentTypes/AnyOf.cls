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
  
  set type = ..NormalizeClassName(..ExpectedType)
      
  if ##class(%Dictionary.CompiledMethod).%ExistsId(type_"||IsValid") {
    return $classmethod(type, "IsValid", input)
  }
  
  return 0
}

Method NormalizeClassName(className As %String) [ Private ]
{
  if className [ "%" {
    return "%Library."_$extract(className, 2, *)
  }
  
  return className
}

}

