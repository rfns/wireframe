Include wireframe

Class Wireframe.Implementation.CodePatcher Extends %RegisteredObject
{

Property Generator As Wireframe.Implementation.CodeGenerator [ Private ];

Property IncludeCache As %ArrayOfDataTypes [ Private ];

Method %OnNew(generator As Wireframe.Implementation.CodeGenerator) As %Status
{
  set ..Generator = generator
  return $$$OK
}

Method Apply(routine As %Routine, methodName As %String) As Wireframe.Implementation.CodeExecutor
{
  set includes = ..PatchIncludes()
  set signature = ..PatchArguments(methodName)
  set arguments = ..Generator.GetMethodImplementationObject(
    methodName
  ).GetDefaultArgumentValues()

  do ..PatchImplementation(routine, methodName, signature, includes)

  set executor = ##class(Wireframe.Implementation.CodeExecutor).%New(
    routine,
    methodName,
    signature,
    arguments
  )

  return executor
}

Method PatchImplementation(routine As %Routine, methodName As %String, signature As %String, includes As %String) [ Private ]
{

  set implementationObject = ..Generator.GetMethodImplementationObject(methodName)
  set implementation = implementationObject.GetContent()

  do ..AppendIncludes(routine, includes)
  do ..WriteLabel(routine, methodName, signature)

  while 'implementation.AtEnd {
    set line = implementation.ReadLine()

    do ..EnsureAsReturnable(implementationObject, .line)
    do ..PatchKillCommands(.line)
    do ..PatchMergeCommands(.line)
    do ..PatchThisReferences(.line)
    do ..PatchClassParameters(.line)

    do routine.WriteLine(line)
  }

  do routine.WriteLine("")
  do routine.WriteLine("  quit """"")
  do routine.WriteLine("")
}

Method PatchClassParameters(ByRef line As %String)
{
  set targetClass = ..Generator.GetTargetClass().%Id()
  set line = $replace(line, "..#", "##class("_targetClass_").#")
}

Method PatchArguments(methodName As %String) As %String [ Private ]
{
  set args = ""
  set methodImplementationObject = ..Generator.GetMethodImplementationObject(methodName)
  set thisObjectSignature = ",injectedSpy)"

  set arguments = methodImplementationObject.GetArgumentList()

  set expectedArgsCount = $ll(arguments)
  for i=1:1:expectedArgsCount {
    set parsedArgSpec = $listget(arguments, i)
    set $list(args, *+1) = $listget(parsedArgSpec, 1)
  }

  if args = "" set thisObjectSignature = "injectedSpy)"
  set args = "("_$lts(args)_thisObjectSignature

  return args
}

Method EnsureAsReturnable(implementationObject As Wireframe.Implementation.MethodMetadata, ByRef line As %String = "") [ Private ]
{
  if implementationObject.IsExpression {
    set line = "  return "_line
  }
}

Method PatchKillCommands(ByRef line As %String) [ Private ]
{
  if ($$$lcase(line) '[ "kill ") && ($$$lcase(line) '[ "k ") return

  set commonMatcher = ##class(%Regex.Matcher).%New("(?:[\s\t]+)?(?:k|K|Kill|kill|KILL)?(\s?+(?:i%|\.{2})([\w\d%]+))(,?)")
  set compositeMatcher = ##class(%Regex.Matcher).%New(commonMatcher.Pattern_"(?=\s)")

  set commonMatcher.Text = line
  set compositeMatcher.Text = line

  set resolvedMatcher = ""

  if compositeMatcher.Locate() {
    set resolvedMatcher = compositeMatcher
  } elseif commonMatcher.Locate() {
    set resolvedMatcher = commonMatcher
  }

  if $isobject(resolvedMatcher) {
    set line = "  do "_resolvedMatcher.ReplaceAll("injectedSpy.""_KillMultiDimensional""(""$2"")$3")
  }
}

Method PatchMergeCommands(ByRef line As %String) [ Private ]
{
  if (line '[ "merge ") && (line '[ "m ") return

  set mergeMatcher = ##class(%Regex.Matcher).%New("(?:[\s\t]+)?(?:m|M|Merge|merge)?(\s?+(?:i%|\.{2})([\w\d%]+))\s+\=\s+([\w\d%]+)(,?)")
  set mergeMatcher.Text = line

  if mergeMatcher.Locate() {
    set line = "  do "_mergeMatcher.ReplaceAll("injectedSpy.""_MergeMultiDimensional""(""$2"", .$3)$4")
  }
}

Method PatchThisReferences(ByRef line As %String = "")
{
  set dotMatcher = ##class(%Regex.Matcher).%New("(?:\.{2})([\w\d%]+)")
  set dotMatcher.Text = line

  set line = dotMatcher.ReplaceAll("injectedSpy.$1")
  set line = $replace(line, "$this", "injectedSpy")
  set line = $replace(line, "%this", "injectedSpy")
  set line = $replace(line, "i%", "injectedSpy.")
}

Method AppendIncludes(routine As %Routine, includes As %String = "") [ Private ]
{
  if routine.Size > 0 {
    $$$ThrowOnError(routine.MoveToEnd())
    $$$ThrowOnError(routine.WriteLine(""))
  } elseif includes '= "" {
    $$$ThrowOnError(routine.Write(includes))
    $$$ThrowOnError(routine.WriteLine(""))
  }
}

Method WriteLabel(routine As %Routine, label As %String, signature As %String) [ Private ]
{
  $$$ThrowOnError(routine.WriteLine(label_signature))
}

Method PatchIncludes() As %String
{
  set includeList = ""
  #dim targetClass As %Dictionary.CompiledClass = ..Generator.GetTargetClass()

  set includeName = ""

  while 1 {
    set includeName = targetClass.IncludeCodeAll.Next(.includeName)
    quit:includeName=""
    continue:..IncludeCache.IsDefined(includeName)

    set $list(includeList, *+1) = "#include "_includeName
    do ..IncludeCache.SetAt("", includeName)
  }

  set includeName = ""

  while 1 {
    set includeName = targetClass.IncludeMGenAll.Next(.includeName)
    quit:includeName=""
    continue:..IncludeCache.IsDefined(includeName)

    if '$listfind(includeList, includeName) {
      set $list(includeList, *+1) = "#include "_includeName
    }

    do ..IncludeCache.SetAt("", includeName)
  }

  if $listlength(includeList) = 0 return ""

  return $listtostring(includeList, $$$NEWLINE)_$$$NEWLINE
}

}

