Class Wireframe.Core.MethodLogger Extends %RegisteredObject
{

Property Controller As Wireframe.Core.LoggerController [ Private ];

Property CallCount As %Integer [ InitialExpression = 0 ];

Property Calls [ MultiDimensional ];

Property LastUsedArguments [ MultiDimensional ];

Property LastException As %Exception.AbstractException;

Property LastReturnedValue;

Method %OnNew(controller As Wireframe.Core.LoggerController) As %Status
{
  set ..Controller = controller
  return $$$OK
}

Method Log(ByRef args = "", exception As %Exception.AbstractException = "", returnValue = "")
{
  if '..Controller.IsEnabled() return
  
  do ..Controller.IncrementCallIndex()
  
  set generalCallIndex = ..Controller.GetCallIndex()
  
  merge i%LastUsedArguments = args
  set ..LastException = exception
  set ..LastReturnedValue = returnValue
  set ..CallCount = ..CallCount + 1
  
  set i%Calls(..CallCount) = ##class(Wireframe.Core.MethodCallLog).%New(
    .args, 
    exception, 
    returnValue,
    generalCallIndex
  )
}

Method GetTimesCalledWithArguments(ByRef args = "") As %Integer
{
   set count = 0
   set key = ""
   for i=1:$order(i%Calls(key)) {
     set key = $order(i%Calls(key), 1, callLog)
     quit:key=""

     merge loggedArgs = callLog.Arguments

     if ##class(Wireframe.Core.Helpers).ArgumentCompare(.loggedArgs, .args) {
       set count = count + 1
     }
   }

   return count
}

Method GetTimesReturnedWithValue(value) As %Integer
{
   set count = 0
   set key = ""
   for i=1:$order(i%Calls(key)) {
     set key = $order(i%Calls(key), 1, callRecord)
     quit:key=""

     set returnValue = callRecord.ReturnedValue

     if returnValue = value {
       set count = count + 1
     }
   }

   return count
}

Method GetCallLogByGeneralCallIndex(generalCallIndex As %Integer) As Wireframe.Core.MethodCallLog
{
  set callIdx = ""
  
  for {
    set callIdx = $order(i%Calls(callIdx), 1, callLog)
    quit:callIdx=""
    
    if callLog.GeneralCallIndex = generalCallIndex {
      return callLog
    }
  }
  
  return ""
}

}

