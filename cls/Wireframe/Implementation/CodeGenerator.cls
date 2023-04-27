Class Wireframe.Implementation.CodeGenerator Extends %RegisteredObject
{

Property TargetClass As %Dictionary.ClassDefinition [ Private ];

Property MethodImplementationCache As %ArrayOfObjects [ Private ];

Property Patcher As Wireframe.Implementation.CodePatcher [ Private ];

Property ExecutionContextCache As %ArrayOfObjects [ Private ];

Property BindingRoutine As %RegisteredObject [ Private ];

Method %OnNew(targetClass As %String) As %Status
{
  set ..TargetClass = ##class(%Dictionary.CompiledClass).%OpenId(targetClass)
  set ..Patcher = ##class(Wireframe.Implementation.CodePatcher).%New($this)
  set ..BindingRoutine = ..CreateBindingRoutine()

  return $$$OK
}

Method GetTargetClass() As %Dictionary.MethodDefinition
{
  return ..TargetClass
}

Method Generate(methodName As %String) As Wireframe.Implementation.CodeExecutor
{
  if ..ExecutionContextCache.IsDefined(methodName) {
    return ..ExecutionContextCache.GetAt(methodName)
  }

  set executionContext = ..Patcher.Apply(..BindingRoutine, methodName)

  $$$ThrowOnError(..BindingRoutine.%Save())
  $$$ThrowOnError(..BindingRoutine.Compile("/nodisplay/keepsource"))

  do ..ExecutionContextCache.SetAt(executionContext, methodName)
  return executionContext
}

Method CreateBindingRoutine() As %Routine [ Private ]
{

  if $isobject(..BindingRoutine) {
    return ..BindingRoutine
  }

  set routineName = ..GenerateRoutineName()_".mac"

  set ..BindingRoutine = ##class(%Routine).%New(routineName)
  return ..BindingRoutine
}

Method GenerateRoutineName() As %String [ Private ]
{
  return "Wireframe.BindingRoutine"_..GetTargetClassHash()
}

Method GetTargetClassHash() As %String
{
  return $$$lcase(##class(%xsd.hexBinary).LogicalToXSD($System.Encryption.SHA1Hash($System.Encryption.GenCryptRand(16))))
}

Method GetMethodImplementationObject(methodName As %String) As Wireframe.Implementation.MethodMetadata
{
  if ..MethodImplementationCache.IsDefined(methodName) {
    return ..MethodImplementationCache.GetAt(methodName)
  }

  set descriptor = ##class(%Dictionary.CompiledMethod).%OpenId(..TargetClass.Name_"||"_methodName)
  set methodMetadata = ##class(Wireframe.Implementation.MethodMetadata).%New(descriptor)

  do ..MethodImplementationCache.SetAt(methodMetadata, methodName)

  return methodMetadata
}

Method %OnClose() As %Status
{

  if $isobject(..BindingRoutine) {
    do ..BindingRoutine.Delete(..BindingRoutine.Name_".mac")
  }

  return $$$OK
}

}

