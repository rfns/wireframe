Class Wireframe.Core.MethodCallLog Extends %RegisteredObject
{

Property ExceptionThrown As %Exception.AbstractException [ ReadOnly ];

Property ReturnedValue As %String [ ReadOnly ];

Property Arguments As %String [ MultiDimensional, ReadOnly ];

Property GeneralCallIndex As %Integer [ ReadOnly ];

Method %OnNew(ByRef args = "", exception As %Exception.AbstractException = "", returnValue = "", generalCallIndex As %Integer) As %Status
{
  set r%ExceptionThrown = exception
  set i%ReturnedValue = returnValue
  set i%GeneralCallIndex = generalCallIndex
  
  merge i%Arguments = args
  
  return $$$OK
}

}

