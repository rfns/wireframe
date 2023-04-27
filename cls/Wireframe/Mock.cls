Class Wireframe.Mock Extends %RegisteredObject
{

Property Stub As Wireframe.Core.Stub [ Private ];

Method %OnNew(className As %RegisteredObject = "", args...) As %Status
{
  set ..Stub = ##class(Wireframe.Core.Stub).%New(className, args...)
  return $$$OK
}

Method When() As Wireframe.Core.BehaviorTrack
{
  return ..Stub.AddBehaviorTrack()
}

Method GetObject() As Wireframe.Spy
{
  return ..Stub.GetSpy()
}

Method GetArgumentMatcher() As Wireframe.Core.ArgumentMatcher
{
  return ##class(Wireframe.Core.ArgumentMatcher).%New()
}

}

