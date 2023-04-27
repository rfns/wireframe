Class Wireframe.ArgumentTypes.ByRef Extends (%RegisteredObject, Wireframe.Core.MatchableArgument)
{

Method Match(ByRef input) As %Boolean
{
  return $data(input) = 11
}

}

