Class Wireframe.Core.ExpectationVerifier Extends %RegisteredObject
{

Property Mock As Wireframe.Mock [ Private ];

Method %OnNew(mock As Wireframe.Mock) As %Status
{
  set ..Mock = mock
  return $$$OK
}

Method Verify(methodName As %String = "") As %Status
{
  set sc = $$$OK
  set expectations = ..Mock.GetBridge().GetCoordinator().GetExpectationMatchers(methodName)  
  
  for i=1:1:expectations.Count() {
    set expectation = expectations.GetAt(i)
    set methodLogger = ..Mock.GetObject().ForMethod(expectation.GetMethodName())
    set sc = $$$ADDSC(sc, expectation.Met(methodLogger))
  }
  
  return sc
}

}

