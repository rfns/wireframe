Class Wireframe.Core.MethodCallLog Extends %RegisteredObject
{

Property ExceptionThrown As %Exception.AbstractException [ ReadOnly ];

Property ReturnedValue As %String [ ReadOnly ];

Property Arguments As %String [ MultiDimensional, ReadOnly ];

Property ExpectedCallIndex As %Integer [ ReadOnly ];

Method %OnNew(ByRef args = "", exception As %Exception.AbstractException = "", returnValue = "", expectedCallIndex As %Integer) As %Status
{
  set r%ExceptionThrown = exception
  set i%ReturnedValue = returnValue
  set i%ExpectedCallIndex = expectedCallIndex
  
  merge i%Arguments = args
  
  return $$$OK
}

}

