Class Wireframe.Core.ExpectationVerifier Extends (%RegisteredObject, Wireframe.Core.AbstractExpectationVerifier)
{

Method OnVerify(expectation As Wireframe.Core.ExpectationMatcher, methodLogger As Wireframe.Core.MethodLogger) As %Status
{
  return expectation.MetByOcurrence(methodLogger)
}

}

