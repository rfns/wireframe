Class Wireframe.Core.Helpers Extends %RegisteredObject
{

ClassMethod ArgumentCompare(ByRef inputs = "", ByRef matchers As Wireframe.Core.MatchableArgument = "") As %Boolean
{
  if $data(inputs) < 2 return 0
  if inputs '= matchers return 0

  for i=1:1:inputs {
    set matcher = matchers(i)

    do ..NormalizeSubscripts(i, .inputs, .argument)

    if 'matcher.Match(.argument) {
      return 0
    }
  }

  return 1

NormalizeInput(subscript, normalizedInput)
  if $data(inputs) = 11 && ($order(inputs(1, ""), -1) = inputs) {
    set normalizedInput = inputs(1,subscript)
    merge normalizedInput(subscript) = inputs(1,subscript)
  } else {
    set currentInput = inputs(subscript)
  }
}

ClassMethod NormalizeSubscripts(i, ByRef in, Output out)
{
  if $data(in) = 11 && ($data(in(i, 1)) = 1) {
    set out = $order(in(i,""))
    merge out(i) = in(i)
  } else {
    set out = in(i)
  }
}

ClassMethod CopyProperties(src As %RegisteredObject, dest As Wireframe.Core.Stub)
{
  if '$isobject(src) return

  set properties = ""
  do ##class(%Studio.General).DumpObjectExecute(.properties, src)

  set key = ""
  for {
    set key = $order(properties(key))
    quit:key=""

    set useXecute = 0

    set name = key
    if name [ "[r%]" set name = $replace(key, "[r%]", "")
    if name [ "(" set useXecute = 1

    set value = properties(key)
    set isObject = $data(properties(name_"[r%]"))
    if value = "<UNDEFINED>" set value = ""
    if isObject && (value = "") continue

    try {
      if 'useXecute {
        set $property(dest, name) = value
      } else {
        xecute ($$$FormatText("(thisObject) set thisObject.%1 = ""%2""", name, value), dest)
      }
    } catch ex {
      set errorText = $System.Status.GetErrorText(ex.AsStatus())
      $$$ThrowStatus($$$ERROR($$$GeneralError, $$$FormatText("Failed to copy property %1. Reason: %2", name, errorText)))
    }
  }
}

ClassMethod SerializeArguments(ByRef args = "") As %String
{
  set key = ""
  set argsList = ""

  for  {
    set key=$order(args(key))
    quit:key=""
    
    merge arg = args(key)
    
    if $data(args(key)) > 1  set arg = "(MultiDimensional)"
    if $isobject(arg) && arg.%Extends("Wireframe.Core.MatchableArgument") {
      if arg.%IsA("Wireframe.ArgumentTypes.Is") {
        set arg = arg.UnwrapValue()
      } else {
        set arg = "<arg."_arg.%ClassName()_"()>"
      }
    }

    set $list(argsList, *+1) = arg

  }
  return $lts(argsList)
}

}

