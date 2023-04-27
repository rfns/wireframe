Class Wireframe.Core.MethodLogger Extends %RegisteredObject
{

Property CallCount As %Integer [ InitialExpression = 0 ];

Property Calls [ MultiDimensional ];

Property LastUsedArguments [ MultiDimensional ];

Property LastException As %Exception.AbstractException;

Property LastReturnedValue;

Property CalledWithArgumentNTimes As %Integer [ MultiDimensional ];

Method Log(ByRef args = "", exception As %Exception.AbstractException = "", returnValue = "")
{
  merge i%LastUsedArguments = args
  set ..LastException = exception
  set ..LastReturnedValue = returnValue
  set ..CallCount = ..CallCount + 1
  set i%Calls(..CallCount) = ##class(Stick.Spy.CallRecord).%New(.args, exception, returnValue)
}

Method GetTimesCalledWithArguments(ByRef args = "") As %Integer
{
   set count = 0
   set key = ""
   for i=1:$order(i%Calls(key)) {
     set key = $order(i%Calls(key), 1, callRecord)
     quit:key=""

     kill recordArgs
     merge recordArgs = callRecord.Arguments

     if ##class(Stick.Helper).ArgumentCompare(.args, .recordArgs) {
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

}

