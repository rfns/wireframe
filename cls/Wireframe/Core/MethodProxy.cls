Include wireframe

Class Wireframe.Core.MethodProxy Extends %RegisteredObject
{

Property Consolidator As Wireframe.Core.BridgeConsolidator [ Private ];

Property Generator As Wireframe.Implementation.CodeGenerator [ Private ];

Property Spy As Wireframe.Spy [ MultiDimensional ];

Method %OnNew(spy As Wireframe.Spy) As %Status
{
  set ..Spy = spy
  do ..AttemptToLinkRealObject(spy.GetRealObject())

  return $$$OK
}

Method SetConsolidator(consolidator As Wireframe.Core.BridgeConsolidator)
{
  set ..Consolidator = consolidator
}

Method AttemptToLinkRealObject(realObject As %RegisteredObject) [ Private ]
{
  if '$isobject(realObject) return
  set ..Generator = ##class(Wireframe.Implementation.CodeGenerator).%New($classname(realObject))
}

Method InterceptCall(methodName As %String, args...)
{
  set realMethodName = $$$RealMethodName(methodName)
  set behavior = ..CheckForBehavior(methodName, args...)

  return ..ResolveCall(realMethodName, behavior, args...)
}

Method CheckForBehavior(methodName, args...)
{
  if '$isobject(..Consolidator) return ""

  return ..Consolidator.GetNextBehavior(methodName, args...)
}

Method ResolveCall(methodName As %String, behavior As Wireframe.Core.AbstractBehavior = "", args...) [ Private ]
{
  set realMethodName = $$$RealMethodName(methodName)

  if '$isobject(behavior) || behavior.IsPassthrough() {
    return ..ForwardToImplementation(methodName, args...)
  }

  set returnValue = behavior.GetValueToReturn()
  set exception = behavior.GetExceptionToThrow()

  do ..Spy.ForMethod(realMethodName).Log(.args, exception, returnValue)

  if $isobject(exception) && exception.%IsA("%Exception.AbstractException") {
    throw exception
  }

  return returnValue
}

Method ForwardToImplementation(methodName As %String, args...) [ Internal, Private ]
{
  set returnValue = ""
  set exception = ""
  set realMethodName = $$$RealMethodName(methodName)

  if $isobject(..Generator) {
    try {
      set returnValue = ..Generator.Generate($$$SubstituteMethodName(methodName)).Run(..Spy, args...)
    } catch ex {
      set exception = ex
    }
  }

  do ..Spy.ForMethod(realMethodName).Log(.args, exception, returnValue)

  return returnValue
}

}

