Class Wireframe.Core.MockCoordinator Extends Wireframe.Core.AbstractCoordinator
{

Property ExpectationMatchers As list Of Wireframe.Core.ExpectationMatcher [ Private ];

Property ExpectedCallCounts As %Integer [ Private ];

Method OnSetupRecorder(methodName As %String) As Wireframe.Core.BehaviorRecorder [ Private ]
{
 
  set expectationFactory = ##class(Wireframe.Core.MockExpectationFactory).%New()
  set recorder = ##class(Wireframe.Core.BehaviorRecorder).%New(
    $this,
    expectationFactory
  )  

  return recorder
}

Method OnBehaviorSet(behavior As Wireframe.Core.MockExpectation)
{
  do ..ExpectationMatchers.Insert(##class(Wireframe.Core.ExpectationMatcher).%New(behavior))
}

Method OnGetNextBehavior(behavior As Wireframe.Core.MockExpectation, methodName As %String, args...) As Wireframe.Core.BehaviorState [ Private ]
{
    
  if $isobject(behavior) {
    return behavior.GetState()
  }
  
  return ""
}

Method GetExpectationMatchers(methodName As %String = "") As %ListOfObjects
{
   
  set list = ..ExpectationMatchers
  
  if methodName '= "" {
    set list = ##class(%ListOfObjects).%New()
    for i=1:1:..ExpectationMatchers.Count() {
      set expectation = ..ExpectationMatchers.GetAt(i)
      if expectation.GetMethodName() = methodName {
        do list.Insert(expectation)
      }
    }
  }
  
  return list
}

}

