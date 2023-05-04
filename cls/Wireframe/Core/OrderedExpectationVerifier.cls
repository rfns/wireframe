Class Wireframe.Core.OrderedExpectationVerifier Extends (%RegisteredObject, Wireframe.Core.AbstractExpectationVerifier)
{

Method OnVerify(expectation As Wireframe.Core.ExpectationMatcher, methodLogger As Wireframe.Core.MethodLogger, index As %Integer) As %Status
{
  return expectation.Met(methodLogger, index)
}

}

