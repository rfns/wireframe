Class Wireframe.Core.AbstractTestDouble [ Abstract ]
{

Property Consolidator As Wireframe.Core.BridgeConsolidator [ Private ];

Property Bridge As Wireframe.Core.AbstractCoordinatorBridge [ Private ];

Property ClassName As %String [ Private ];

Property ConstructorArgs [ MultiDimensional, Private ];

Property Spy As Wireframe.Spy [ Private ];

Method %OnNew(className As %String = "", constructorArgs...) As %Status
{
  
  set ..ClassName = className
  
  merge i%ConstructorArgs = constructorArgs 
  
  do ..InitializeSpy()   
  do ..SetConsolidator(##class(Wireframe.Core.BridgeConsolidator).%New())

  return $$$OK
}

Method SetConsolidator(consolidator As Wireframe.Core.BridgeConsolidator)
{
  set ..Consolidator = consolidator
  set ..Bridge = ..OnSetBridge(..Consolidator)
  
  do ..Spy.UseThisConsolidator(..Consolidator)
}

Method GetConsolidator() As Wireframe.Core.BridgeConsolidator
{
  return ..Consolidator
}

Method OnSetBridge() As Wireframe.Core.AbstractCoordinatorBridge [ Abstract, Private ]
{
  $$$ThrowStatus($$$ERROR($$$MethodNotImplemented, "OnSetBridge"))
}

Method GetBridge() As Wireframe.Core.AbstractCoordinatorBridge [ Final ]
{
  return ..Bridge
}

Method GetObject() As Wireframe.Spy [ Final ]
{
  return ..Spy
}

Method SetSpy(newSpy As Wireframe.Spy) [ Final, Private ]
{
  set ..Spy = newSpy
}

Method GetArgumentMatcher() As Wireframe.Core.ArgumentMatcher [ Final ]
{
  return ##class(Wireframe.Core.ArgumentMatcher).%New()
}

Method InitializeSpy()
{
  if ..ClassName = "" {
    set ..Spy = ##class(Wireframe.Spy).%New()
  } else {
    merge args = i%ConstructorArgs
    set object = $classmethod(..ClassName, "%New", args...)
    set ..Spy = ##class(Wireframe.Spy).%New(object)
  }

  return ..Spy
}

Method Clear(methodName As %String = "")
{
 
  do ..Spy.Clear(methodName)
  do ..Consolidator.Clear(methodName)
}

Method Reset(methodName As %String = "")
{
  do ..Spy.Clear(methodName)
  do ..Consolidator.Reset(methodName)
}

}

