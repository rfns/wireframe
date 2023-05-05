Class Wireframe.Mock Extends (%RegisteredObject, Wireframe.Core.AbstractTestDouble)
{

Property Stub As Wireframe.Core.Stub [ Private ];

Method OnSetBridge(consolidator As Wireframe.Core.BridgeConsolidator) As Wireframe.Core.ExpectationBridge [ Private ]
{
  return consolidator.SetAndReturnExpectationBridge(
    ##class(Wireframe.Core.ExpectationBridge).%New()
  )
}

Method When() As Wireframe.Core.BehaviorBridge
{
  merge args = i%ConstructorArgs
  
  if '$isobject(..Stub) {    
    set ..Stub = ##class(Wireframe.Core.Stub).%New(..ClassName, args...)
    do ..Stub.UseFromMockFactory($this)
  }   
  
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

Method GetOrderedVerifier() As Wireframe.Core.OrderedExpectationVerifier
{
  return ##class(Wireframe.Core.OrderedExpectationVerifier).%New($this)
}

Method Verify(methodName As %String = "")
{
  return ..GetVerifier().Verify()
}

Method VerifyInOrder(methodName As %String = "")
{
  return ..GetOrderedVerifier().Verify(methodName)
}

}

