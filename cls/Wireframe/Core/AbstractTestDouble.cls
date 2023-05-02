Class Wireframe.Core.AbstractTestDouble [ Abstract ]
{

Property Bridge As Wireframe.Core.AbstractCoordinatorBridge [ Private ];

Property ClassName As %String [ Private ];

Property ConstructorArgs [ MultiDimensional, Private ];

Property Spy As Wireframe.Spy [ Private ];

Method %OnNew(className As %String = "", constructorArgs...) As %Status
{

  set ..ClassName = className

  merge i%ConstructorArgs = constructorArgs

  set ..Bridge = ..OnSetBridge()

  do ..InitializeSpy(
    className,
    constructorArgs...
  ).UseThisCoordinator(..Bridge.GetCoordinator())

  return $$$OK
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

Method InitializeSpy(className As %String, constructorArgs...)
{
  if className = "" {
    set ..Spy = ##class(Wireframe.Spy).%New()
  } else {
    set object = $classmethod(className, "%New", constructorArgs...)
    set ..Spy = ##class(Wireframe.Spy).%New(object, 1)
  }

  return ..Spy
}

Method Reset()
{
  do ..Spy.Clear()
  do ..Bridge.GetCoordinator().Reset()
}

}

