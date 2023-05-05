Class Wireframe.Implementation.CodeExecutor Extends %RegisteredObject
{

Property Routine As %String [ Private ];

Property Label As %String [ Private ];

Property Signature As %String [ Private ];

Property DefaultArgValues As %String [ Private ];

Method %OnNew(routine As %Routine, label As %String, signature As %String, defaultArgValues As %List) As %Status
{
  set ..Routine = routine
  set ..Label = label
  set ..Signature = signature
  set ..DefaultArgValues = defaultArgValues

  return $$$OK
}

Method Run(bindingArgument, args...)
{
  set ret = ""

  do ..MergeArguments(bindingArgument, .args, .mergedArgs)

  set callPoint = ..CreateXecuteCallPoint()

  try {
    set ret = $xecute(callPoint, mergedArgs...)
  } catch ex {
    set sc = ex.AsStatus()
    if $System.Status.GetErrorText(sc) '[ "<COMMAND>" {
      throw ex
    }
  }

  return ret
}

Method MergeArguments(bindingArgument, ByRef args = 0, Output mergedArgs = 0) [ Private ]
{
  for i=1:1:$ll(..DefaultArgValues) {
    set mergedArgs(i) = $select($data(args(i)) : args(i), 1: $$EvalExpression($listget(..DefaultArgValues, i)))
  }

  set mergedArgs = $ll(..DefaultArgValues) + 1
  set mergedArgs(mergedArgs) = bindingArgument

EvalExpression(exp)
  if exp = "" return exp

  set exp = $replace(exp, "..", "bindingArgument.")

  try {
    xecute ("(result, bindingArgument) set result = "_exp, .result, bindingArgument)
  } catch ex { 
    set result = ""
  }

  return result
}

Method CreateXecuteCallPoint() As %String
{
  return $$$FormatText("%3 return $$%1^%2%3", ..Label, ..Routine.Name, ..Signature)
}

}

