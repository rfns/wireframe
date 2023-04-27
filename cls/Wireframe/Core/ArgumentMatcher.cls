Class Wireframe.Core.ArgumentMatcher Extends %RegisteredObject
{

Method Any() As Wireframe.ArgumentTypes.Any
{
  return ##class(Wireframe.ArgumentTypes.Any).%New()
}

Method AnyOf(type As %String) As Wireframe.ArgumentTypes.AnyOf
{
  return ##class(Wireframe.ArgumentTypes.AnyOf).%New(type)
}

Method Is(data) As Wireframe.ArgumentTypes.Is
{
  return ##class(Wireframe.ArgumentTypes.Is).%New(data)
}

Method ByRef(ByRef args) As Wireframe.ArgumentTypes.ByRef
{
  return ##class(Wireframe.ArgumentTypes.ByRef).%New(.args)
}

Method ByAET(payload As %DynamicAbstractObject) As Wireframe.ArgumentTypes.ByAET
{
  return ##class(Wireframe.ArgumentTypes.ByAET).%New(payload)
}

}

