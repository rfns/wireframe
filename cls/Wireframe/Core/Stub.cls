Class Wireframe.Core.Stub Extends %RegisteredObject
{

Property Coordinator As Wireframe.Core.StubCoordinator [ Private ];

Property Spy As Wireframe.Spy [ Private ];

Method %OnNew(className As %String = "", args...) As %Status [ Private ]
{
  set ..Coordinator = ##class(Wireframe.Core.StubCoordinator).%New($this)
  do ..InitializeSpy(className, args...).UseThisStub($this)
  return $$$OK
}

Method InitializeSpy(className, args...) As Wireframe.Spy [ Private ]
{
  if className = "" {
    set ..Spy = ##class(Wireframe.Spy).%New()
  } else {
    set object = $classmethod(className, "%New", args...)
    set ..Spy = ##class(Wireframe.Spy).%New(object, 1)
  }

  return ..Spy
}

Method GetSpy() As Wireframe.Spy
{
  return ..Spy
}

Method BridgeToBehavior() As Wireframe.Core.BehaviorBridge
{
  return ##class(Wireframe.Core.BehaviorBridge).%New(..Coordinator)
}

Method GetCoordinator() As Wireframe.Core.StubCoordinator
{
  return ..Coordinator
}

}

