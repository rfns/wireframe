Class Wireframe.Core.MockCoordinator Extends (%RegisteredObject, Wireframe.Core.AbstractCoordinator)
{

Property ExpectationMatchers As list Of Wireframe.Core.ExpectationMatcher [ Private ];

Property ExpectedCallsByMethod [ MultiDimensional, Private ];

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
  set expectedCallIndex = ..ExpectationMatchers.Count() + 1

  do ..IncreaseMethodCallLimit(behavior)

  do ..ExpectationMatchers.Insert(
    ##class(Wireframe.Core.ExpectationMatcher).%New(behavior, expectedCallIndex)
  )
}

Method OnGetNextBehavior(behavior As Wireframe.Core.MockExpectation, methodName As %String, args...) As Wireframe.Core.MockExpectationState [ Private ]
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

Method Reset(methodName As %String = "")
{
  do ##super(methodName)

  if methodName '= "" {
    set count = ..ExpectationMatchers.Count()

    for i=1:1:..ExpectationMatchers.Count() {
      set expectation = ..ExpectationMatchers.GetAt(i)
      if expectation.GetMethodName() = methodName {
        do ..ExpectationMatchers.RemoveAt(i)
      }
    }
    do ..ExpectationMatchers.Clear(methodName)

    return
  }

  do ..ExpectationMatchers.Clear()
}

Method IncreaseMethodCallLimit(behavior As Wireframe.Core.MockExpectation)
{
  set methodName = behavior.GetMethodName()
  set i%ExpectedCallsByMethod(methodName) = $get(i%ExpectedCallsByMethod(methodName)) + 1
}

Method GetMethodCallLimit(methodName As %String) As %Integer
{
  return $get(i%ExpectedCallsByMethod(methodName), 0)
}

}

