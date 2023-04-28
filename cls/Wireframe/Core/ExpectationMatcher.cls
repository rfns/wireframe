Class Wireframe.Core.ExpectationMatcher Extends %RegisteredObject
{

Property Expectation As Wireframe.Core.MockExpectation [ Private ];

Method %OnNew(expectation As Wireframe.Core.MockExpectation) As %Status
{
  set ..Expectation = expectation
  return $$$OK
}

Method Met(methodLogger As Wireframe.Core.MethodLogger, index As %Integer = 0) As %Status
{
 
  if index > 0 return ..VerifyOrdered(methodLogger, index) 
  return ..VerifyUnordered(methodLogger)
}

Method GetMethodName() As %String
{
  return ..Expectation.GetMethodName()
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
  
  return ..ValidateExpression(methodName, timesExpected, matches, .expectedArgs, 0)
}

Method VerifyOrdered(index, methodLogger As Wireframe.Core.MethodLogger) As %Status [ Private ]
{
  set matches = methodLogger.Calls(index).CallCount  
  set timesExpected = ..Expectation.GetExpectedTimes()
  set methodName = ..Expectation.GetMethodName()
    
  do ..Expectation.GetState().GetArguments(.expectedArgs)
  merge receivedArgs = methodLogger.Calls(index).Arguments    
  
  if '##class(Wireframe.Core.Helpers).ArgumentCompare(.receivedArgs, .expectedArgs) {
    set serialArgs = ##class(Wireframe.Core.Helpers).SerializeArguments(.receivedArgs)
    return $$$ERROR($$$GeneralError, "Method '"_methodName_"' received unexpected arguments at call #"_index_"(args: "_serialArgs_")")
  }
  
  set matches = methodLogger.Calls(index).CallCount  
  set timesExpected = ..Expectation.GetExpectedTimes()
  
  return ..ValidateExpression(methodName, timesExpected, matches, .receivedArgs, .expectedArgs)
}

Method ValidateExpression(methodName As %String, timesExpected As %Integer, matches As %Integer, ByRef expectedArgs, ByRef receivedArgs) As %Status [ Private ]
{
  set serialExpectedArgs = ##class(Wireframe.Core.Helpers).SerializeArguments(.expectedArgs)
  set serialReceivedArgs = ##class(Wireframe.Core.Helpers).SerializeArguments(.receivedArgs)  
  set descriptiveOperator = ..ConvertOperatorToDescriptive(timesExpected)
  
  if matches = 0 {    
    return $$$ERROR($$$GeneralError, "Expected method '"_methodName_"' to be called "_descriptiveOperator_" time(s) (expected args: "_serialExpectedArgs_")")
  }      
  
  set valid = $xecute($$$FormatText("return (%1 %2)", matches, timesExpected))
  
  if 'valid {
    set errorMessage = $$$FormatText("Expected method '%1' to be called %2 time(s) but got called %3 (expected args: %4).", methodName, ..ConvertOperatorToDescriptive(timesExpected), matches, serialExpectedArgs)
    return $$$ERROR($$$GeneralError, errorMessage)
  }
  
  return $$$OK
}

}

