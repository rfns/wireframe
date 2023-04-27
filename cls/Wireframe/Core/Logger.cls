Class Wireframe.Core.Logger Extends %RegisteredObject
{

Property Methods As Wireframe.Core.MethodLogger [ Private ];

Property Properties As Wireframe.Core.PropertyLogger [ Private ];

Method ForMethod(methodName As %String) As Wireframe.Core.MethodLogger
{
  set logger = $get(i%Methods(methodName))
  if $isobject(logger) return logger

  set logger = ##class(Wireframe.Core.MethodLogger).%New()
  set i%Methods(methodName) = logger
  return logger
}

Method ForProperty(propertyName As %String) As Wireframe.Core.PropertyLogger
{
  set logger = $get(i%Properties(propertyName))
  if $isobject(logger) return logger

  set logger = ##class(Wireframe.Core.PropertyLogger).%New(propertyName)
  set i%Properties(propertyName) = logger
  return logger
}

Method Clear()
{
  kill i%Methods
  kill i%Properties
}

}

