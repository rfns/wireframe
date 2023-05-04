Class Wireframe.Core.AbstractExpectationVerifier [ Abstract ]
{

Property Mock As Wireframe.Mock [ Private ];

Method %OnNew(mock As Wireframe.Mock)
{
  set ..Mock = mock
  return $$$OK
}

Method VerifyOnly(methodName As %String = "") As %Status [ Final ]
{
  set sc = $$$OK
  set expectations = ..Mock.GetBridge().GetCoordinator().GetExpectationMatchers(methodName)  
  
  set errorMessage = $$$ERROR($$$GeneralError, "Verification failed: One or more expectations were NOT met:")
  set expectationsCount = expectations.Count()
  
  if expectationsCount = 0 {
    return $$$ERROR($$$GeneralError, "No expectations were set to this mock.")
  }
  
  for i=1:1:expectationsCount {
    set expectation = expectations.GetAt(i)
    set methodLogger = ..Mock.GetObject().ForMethod(expectation.GetMethodName())
    set sc = $$$ADDSC(sc, ..OnVerify(expectation, methodLogger, i))
  }
  
  if $$$ISERR(sc) set sc = $$$EMBEDSC(errorMessage, sc)  
  
  return sc
}

Method Verify() As %Status [ Final ]
{
  set sc = ..VerifyOnly()
  do ..Mock.Reset()
  
  return sc
}

Method OnVerify(expectation As Wireframe.Core.ExpectationMatcher, methodLogger As Wireframe.Core.MethodLogger, index As %Integer = "") As %Status [ Abstract, Private ]
{
  $$$ThrowStatus($$$ERROR($$$MethodNotImplemented, "OnVerify"))
}

}

