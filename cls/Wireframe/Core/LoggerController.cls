Class Wireframe.Core.LoggerController Extends %RegisteredObject
{

Property Enabled As %Boolean [ InitialExpression = 1, Private ];

Property Methods As Wireframe.Core.MethodLogger [ Private ];

Property Properties As Wireframe.Core.PropertyLogger [ Private ];

Property CallIndex As %Integer [ InitialExpression = 0, Private ];

Method ForMethod(methodName As %String) As Wireframe.Core.MethodLogger
{
  set logger = $get(i%Methods(methodName))
  if $isobject(logger) return logger

  set logger = ##class(Wireframe.Core.MethodLogger).%New($this)
  set i%Methods(methodName) = logger
  return logger
}

Method ForProperty(propertyName As %String) As Wireframe.Core.PropertyLogger
{
 
  set logger = $get(i%Properties(propertyName))
  if $isobject(logger) return logger

  set logger = ##class(Wireframe.Core.PropertyLogger).%New($this)
  set i%Properties(propertyName) = logger
  return logger
}

Method Disable()
{
  set ..Enabled = 0
}

Method Enable()
{
  set ..Enabled = 1
}

Method IsEnabled() As %Boolean
{
  return ..Enabled
}

Method Clear(methodName As %String = "")
{
  if methodName '= "" kill i%Methods(methodName)
  else  kill i%Methods
  
  kill i%Properties
  
  set ..Enabled = 1
}

Method IncrementCallIndex()
{
  set ..CallIndex = ..CallIndex + 1
}

Method GetCallIndex() As %Integer
{
  return ..CallIndex
}

}

