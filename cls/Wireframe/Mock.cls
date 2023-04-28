Class Wireframe.Mock Extends (%RegisteredObject, Wireframe.Core.AbstractTestDouble)
{

Property Stub As Wireframe.Core.Stub [ Private ];

Method OnSetBridge() As Wireframe.Core.ExpectationBridge [ Private ]
{
  return ##class(Wireframe.Core.ExpectationBridge).%New()
}

Method When() As Wireframe.Core.BehaviorBridge
{
  merge args = i%ConstructorArgs
  
  if '$isobject(..Stub) {    
    set ..Stub = ##class(Wireframe.Core.Stub).%New(..ClassName, args...)
  }
  
  do ..SetSpy(..Stub.GetObject())
  
  return ..Stub.GetBridge()
}

Method Expect() As Wireframe.Core.ExpectationBridge
{
  return ..GetBridge()
}

Method GetVerifier() As Wireframe.Core.ExpectationVerifier
{
  return ##class(Wireframe.Core.ExpectationVerifier).%New($this)
}

}

