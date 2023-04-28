Include wireframe

Class Wireframe.Spy Extends %RegisteredObject
{

Property "__Properties__" [ Internal, MultiDimensional, Private ];

Property "__MultiDimensionals__" [ Internal, MultiDimensional, Private ];

Property "__Stub__" As Wireframe.Core.Stub [ Internal, Private ];

Property "__Proxy__" As Wireframe.Core.MethodProxy [ Internal, Private ];

Property "__Logger__" As Wireframe.Core.LoggerController [ Internal, Private ];

Property "__RealObject__" As %RegisteredObject [ Internal, Private ];

Method %OnNew(object As %String = "", replayConstructor As %Boolean = 0) As %Status
{

  set .."__Logger__" = ##class(Wireframe.Core.LoggerController).%New()

  do ..AssertObjectIsNotAnotherSpy(object)
  do ..SetRealObject(object, replayConstructor)

  set .."__Proxy__" = ##class(Wireframe.Core.MethodProxy).%New($this)  

  return $$$OK
}

Method AssertObjectIsNotAnotherSpy(object As %RegisteredObject = "") [ Internal, Private ]
{
  if $isobject(object) {
    if object.%IsA($classname()) {
      $$$ThrowStatus($$$ERROR($$$GeneralError, "Spied object cannot be another spy."))
    }
  }
}

Method UseThisStub(stub As Wireframe.Core.Stub)
{
  set .."__Stub__" = stub
  do .."__Proxy__".SetCoordinator(stub.GetCoordinator())
  return $this
}

Method GetRealObject() As %RegisteredObject
{
  return .."__RealObject__"
}

Method SetRealObject(object As %RegisteredObject, replayConstructor As %Boolean = 0) As %RegisteredObject
{
  do .."__Logger__".Disable()
  
  set .."__RealObject__" = object
  do ..FillUsingRealObject(replayConstructor)
  
  do .."__Logger__".Enable()
}

Method FillUsingRealObject(replayConstructor As %Boolean = 0) [ Internal, Private ]
{
  do .."__Logger__".Disable()
  
  do ##class(Wireframe.Core.Helpers).CopyProperties(..GetRealObject(), $this)

  if replayConstructor = 1 do .."__MethodProxy__".InterceptCall("_%OnNew")

  do .."__Logger__".Enable()
}

Method %DispatchMethod(methodName As %String, args...)
{
  if .."_MultiDimensionalExists"(methodName, .args) {
    return .."_GetMultiDimensionalValue"(methodName, .args)
  }

  return .."__Proxy__".InterceptCall(methodName, args...)
}

Method %DispatchSetProperty(propertyName As %String, value) [ ServerOnly = 1 ]
{
  set propertySpy = ..ForProperty(propertyName)

  do propertySpy.RecordSetOperation(value)

  set .."__Properties__"(propertyName) = value
}

Method %DispatchGetProperty(propertyName As %String)
{
  if .."_MultiDimensionalExists"(propertyName) {
    return .."_GetMultiDimensionalValue"(propertyName)
  }

  set propertySpy = ..ForProperty(propertyName)
  set valueExists = $data(i%"__Properties__"(propertyName))

  set value = $get(i%"__Properties__"(propertyName))

  if 'valueExists {
    set value = ..%New()
    set i%"__Properties__"(propertyName) = value
  }

  do propertySpy.RecordGetOperation(value)

  return value
}

Method ForMethod(methodName As %String) As Wireframe.Core.MethodLogger
{
  return .."__Logger__".ForMethod(methodName)
}

Method ForProperty(propertyName As %String) As Wireframe.Core.PropertyLogger
{
  return .."__Logger__".ForProperty(propertyName)
}

Method Clear()
{
  kill i%"__Properties__"
  kill i%"__MultiDimensionals__"
  kill i%"__Proxy__"
  kill i%"__Generator__"

  if $isobject(..RealObject) do .."_FillUsingRealObject"()

  set .."__Proxy__" = ##class(Wireframe.Core.MethodProxy).%New($this)

  do .."__Logger__".Clear()
}

Method %DispatchSetMultidimProperty(property As %String, value, subscripts...)
{
  $$$MultiAsSerial(subscripts, serializedSubs)
  set @($$$FormatText("i%""__MultiDimensionals__""(""%1"", %2)", property, $lts(serializedSubs))) = value
}

Method "_MultiDimensionalExists"(name As %String, ByRef subscripts = "") As %Boolean [ Internal, Private ]
{
  if subscripts = "" return 0
  $$$IsValidMulti(subscripts)
  $$$MultiAsSerial(subscripts, serializedSubs)
  return $data(@($$$FormatText("i%""__MultiDimensionals__""(""%1"", %2)", name, $lts(serializedSubs))))
}

Method "_GetMultiDimensionalValue"(name As %String, ByRef subscripts = "") [ Internal, Private ]
{
  if '.."_MultiDimensionalExists"(name, .subscripts) return ""
  if subscripts < 1 $$$ThrowStatus($$$ERROR($$$GeneralError, "Listing multidimensional values is not allowed when using spy."))

  $$$MultiAsSerial(subscripts, serializedSubs)
  return $get(@($$$FormatText("i%""__MultiDimensionals__""(""%1"", %2)", name, $lts(serializedSubs))))
}

Method "_KillMultiDimensional"(name) [ Internal ]
{
  kill i%"__MultiDimensionals__"(name)
}

Method "_MergeMultiDimensional"(name As %String, ByRef value, subscripts...) [ Internal ]
{
  if $get(subscripts, 0) < 0 {
    $$$MultiAsSerial(subscripts, serializedSubs)
    merge @($$$FormatText("i%""__MultiDimensionals__""(""%1"", %2)", name, $lts(serializedSubs))) = value

    return
  }

  merge i%"__MultiDimensionals__"(name) = value
}

}

