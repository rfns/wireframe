Class Wireframe.Core.BehaviorRecorder Extends %RegisteredObject
{

Property MethodName As %String [ Private ];

Property Behaviors As list Of Wireframe.Core.Behavior [ Private ];

Property StubCoordinator As Wireframe.Core.StubCoordinator [ Private ];

Property CallIndex As %Integer [ Private ];

Method %OnNew(coordinator As Wireframe.Core.StubCoordinator) As %Status
{
  set ..StubCoordinator = coordinator
  return $$$OK
}

Method AppendNewBehavior() As Wireframe.Core.Behavior
{
  set newBehavior = ##class(Wireframe.Core.Behavior).%New($this)
  do ..Behaviors.Insert(newBehavior)

  return newBehavior
}

Method CloneCurrentBehavior() As Wireframe.Core.Behavior
{
  set lastBehaviorIndex = ..Behaviors.Count()
  set behavior = ..Behaviors.GetAt(lastBehaviorIndex)

  set clonedBehavior = behavior.%ConstructClone()
  do ..Behaviors.Insert(clonedBehavior)

  return clonedBehavior
}

Method GetNextBehavior(args...) As Wireframe.Core.Behavior
{

  set nextIndex = ..FindIndexOfNextMatchingBehavior(args...)
  if nextIndex < 1 return ""

  set nextBehavior = ..Behaviors.GetAt(nextIndex)
  do ..Behaviors.RemoveAt(nextIndex)

  return nextBehavior
}

Method FindIndexOfNextMatchingBehavior(args...) As %Integer [ Private ]
{
  for i=1:1:..Behaviors.Count() {
    set behavior = ..Behaviors.GetAt(i)
    do behavior.GetArguments(.recordedArgs)

    if ##class(Wireframe.Core.Helpers).ArgumentCompare(.args, .recordedArgs) {
      return i
    }
  }

  return 0
}

Method Begin(args...) As Wireframe.Core.Behavior
{

  do ..StubCoordinator.SetRecorder($this)
  return ..AppendNewBehavior().ReceiveArguments(args...)
}

Method SetMethodName(methodName As %String)
{
  set ..MethodName = methodName
}

Method GetMethodName()
{
  return ..MethodName
}

}

