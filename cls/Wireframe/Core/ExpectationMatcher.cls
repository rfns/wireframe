Class Wireframe.Core.ExpectationMatcher Extends %RegisteredObject
{

Property Expectation As Wireframe.Core.MockExpectation [ Private ];

Property ExpectedCallIndex As %Integer [ Private ];

Method %OnNew(expectation As Wireframe.Core.MockExpectation, expectedCallIndex As %Integer) As %Status
{
  set ..Expectation = expectation
  set ..ExpectedCallIndex = expectedCallIndex  
  return $$$OK
}

Method MetByOcurrence(methodLogger As Wireframe.Core.MethodLogger) As %Status
{
   
  return ..VerifyUnordered(methodLogger)
}

Method MetByMatchingOrder(methodLogger As Wireframe.Core.MethodLogger) As %Status
{
 
  return ..VerifyOrdered(methodLogger)
}

Method ConvertOperatorToDescriptive(times As %String) [ Private ]
{
  if times [ ">=" return "AT LEAST"_$replace(times, ">=", "")
  if times [ "<=" return "AT MOST"_$replace(times, "<=", "")
  
  return "EXACTLY"_$replace(times, "=", "")
}

Method VerifyUnordered(methodLogger As Wireframe.Core.MethodLogger) As %Status [ Private ]
{
  do ..Expectation.GetState().GetArguments(.expectedArgs)   
  
  set matches = methodLogger.GetTimesCalledWithArguments(.expectedArgs)
  set timesExpected = ..Expectation.GetExpectedTimes()
  set methodName = ..Expectation.GetMethodName()
  
  return ..ValidateExpression(methodName, timesExpected, matches, .expectedArgs)
}

Method GetMethodName() As %String
{
  return ..Expectation.GetMethodName()
}

Method VerifyOrdered(methodLogger As Wireframe.Core.MethodLogger) As %Status [ Private ]
{
  set timesExpected = ..Expectation.GetExpectedTimes()
  set methodName = ..Expectation.GetMethodName()
  set receivedArgs = ""
    
  do ..Expectation.GetState().GetArguments(.expectedArgs)  
  
  set callLog = methodLogger.GetCallByExpectedIndex(..ExpectedCallIndex)
  set serialExpectedArgs = ##class(Wireframe.Core.Helpers).SerializeArguments(.expectedArgs)
  
  if $isobject(callLog) {
    merge receivedArgs = callLog.Arguments
  } else {
    return $$$ERROR($$$GeneralError, $$$FormatText("Expected method '%1' to be called at call #%2 (with args: %3).", methodName, ..ExpectedCallIndex, serialExpectedArgs))
  }  
  
  if '##class(Wireframe.Core.Helpers).ArgumentCompare(.receivedArgs, .expectedArgs) {
    set serialReceivedArgs = ##class(Wireframe.Core.Helpers).SerializeArguments(.receivedArgs)
    return $$$ERROR($$$GeneralError, $$$FormatText("Method '%1' received unexpected arguments at call #%2 (received: %3) / (expected: %4)", methodName, ..ExpectedCallIndex, serialReceivedArgs, serialExpectedArgs))
  }
  
  return ..VerifyUnordered(methodLogger)
}

Method ValidateExpression(methodName As %String, timesExpected As %Integer, matches As %Integer, ByRef expectedArgs, ByRef receivedArgs) As %Status [ Private ]
{
  set serialExpectedArgs = ##class(Wireframe.Core.Helpers).SerializeArguments(.expectedArgs)
  set descriptiveOperator = ..ConvertOperatorToDescriptive(timesExpected)
  
  if matches = 0 {    
    return $$$ERROR($$$GeneralError, $$$FormatText("Expected method '%1' to be called %2 time(s) (receiving args: %3)", methodName, descriptiveOperator, serialExpectedArgs))
  }      
  
  set valid = $xecute($$$FormatText("return (%1 %2)", matches, timesExpected))
  
  if 'valid {
    set errorMessage = $$$FormatText("Expected method '%1' to be called %2 time(s) (receiving args: %3) but got called %4.", methodName, ..ConvertOperatorToDescriptive(timesExpected), serialExpectedArgs, matches)
    return $$$ERROR($$$GeneralError, errorMessage)
  }
  
  return $$$OK
}

}

