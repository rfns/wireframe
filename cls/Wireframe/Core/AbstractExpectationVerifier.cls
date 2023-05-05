Class Wireframe.Core.AbstractExpectationVerifier [ Abstract ]
{

Property Mock As Wireframe.Mock [ Private ];

Property AnnouncedCallLimits [ MultiDimensional, Private ];

Method %OnNew(mock As Wireframe.Mock)
{
  set ..Mock = mock
  return $$$OK
}

Method VerifyOnly(methodName As %String = "") As %Status [ Final ]
{
  set sc = $$$OK
  
  do ..ResetCallLimitAnnouncements()  
  
  set coordinator = ..Mock.GetBridge().GetCoordinator()  
  set expectations = coordinator.GetExpectationMatchers(methodName)  
  
  set errorMessage = $$$ERROR($$$GeneralError, "Verification failed: One or more expectations were NOT met:")
  set expectationsCount = expectations.Count()
  
  if expectationsCount = 0 {
    return $$$ERROR($$$GeneralError, "No expectations were set to this mock.")
  }
  
  
  for i=1:1:expectationsCount {
    set expectation = expectations.GetAt(i)
    set expectationMethodName = expectation.GetMethodName()
    set callLimit = coordinator.GetMethodCallLimit(expectationMethodName)
    set methodLogger = ..Mock.GetObject().ForMethod(expectationMethodName)
    
    set sc = $$$ADDSC(sc, ..VerifyCallLimitForMethod(expectationMethodName, methodLogger, callLimit))
    set sc = $$$ADDSC(sc, ..OnVerify(expectation, methodLogger))
  }
  
  if $$$ISERR(sc) set sc = $$$EMBEDSC(errorMessage, sc)  
  
  return sc
}

Method VerifyCallLimitForMethod(expectationMethodName As %String, methodLogger As Wireframe.Core.MethodLogger, callLimit As %Integer) As %String
{
    
  if ..IsCallLimitAlreadyAnnounced(expectationMethodName) {
    return $$$OK
  }
  
  do ..RecordedCallLimitAnnouncement(expectationMethodName)
  
  set callCount = methodLogger.CallCount
  
  if methodLogger.CallCount '= callLimit {
    $$$QuitOnError($$$ERROR($$$GeneralError, $$$FormatText("Expected method '%1' to be called %2 times, got called %3 times instead.", expectationMethodName, callLimit, callCount)))
  }   
  return $$$OK
}

Method Verify(methodName As %String = "") As %Status [ Final ]
{
  set sc = ..VerifyOnly(methodName)
  do ..Mock.Reset(methodName)
  
  return sc
}

Method OnVerify(expectation As Wireframe.Core.ExpectationMatcher, methodLogger As Wireframe.Core.MethodLogger, index As %Integer = "") As %Status [ Abstract, Private ]
{
  $$$ThrowStatus($$$ERROR($$$MethodNotImplemented, "OnVerify"))
}

Method IsCallLimitAlreadyAnnounced(methodName As %String)
{
  return $get(i%AnnouncedCallLimits(methodName), 0)
}

Method RecordedCallLimitAnnouncement(methodName As %String)
{
  set i%AnnouncedCallLimits(methodName) = 1
}

Method ResetCallLimitAnnouncements()
{
  kill i%AnnouncedCallLimits
}

}

