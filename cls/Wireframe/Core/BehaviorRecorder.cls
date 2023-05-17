Class Wireframe.Core.BehaviorRecorder Extends %RegisteredObject
{

Property MethodName As %String [ Private ];

Property Behaviors As list Of Wireframe.Core.AbstractBehavior [ Private ];

Property Coordinator As Wireframe.Core.AbstractCoordinator [ Private ];

Property BehaviorFactory As Wireframe.Core.AbstractBehaviorFactory [ Private ];

Property BehaviorIndex As %Integer [ InitialExpression = 0, Private ];

Method %OnNew(coordinator As Wireframe.Core.AbstractCoordinator, behaviorFactory As Wireframe.Core.AbstractBehaviorFactory) As %Status
{
  set ..Coordinator = coordinator
  set ..BehaviorFactory = behaviorFactory
  return $$$OK
}

Method AppendNewBehavior() As Wireframe.Core.AbstractBehaviorFactory
{
  
  set newBehavior = ..BehaviorFactory.Create($this)  
  
  do ..Coordinator.OnBehaviorSet(newBehavior)
  do ..Behaviors.Insert(newBehavior)

  return newBehavior
}

Method CloneCurrentBehavior() As Wireframe.Core.AbstractBehavior
{
  set lastBehaviorIndex = ..Behaviors.Count()
  set behavior = ..Behaviors.GetAt(lastBehaviorIndex)

  set clonedBehavior = behavior.%ConstructClone()
  
  do ..Coordinator.OnBehaviorSet(clonedBehavior)
  do ..Behaviors.Insert(clonedBehavior)

  return clonedBehavior
}

Method GetNextBehavior(args...) As Wireframe.Core.AbstractBehavior
{

  set nextIndex = ..FindIndexOfNextMatchingBehavior(args...)
  if nextIndex < 1 return ""

  set nextBehavior = ..Behaviors.GetAt(nextIndex)
  set ..BehaviorIndex  = nextIndex  

  return nextBehavior
}

Method FindIndexOfNextMatchingBehavior(args...) As %Integer [ Private ]
{
  set offsetIndex = ..BehaviorIndex + 1
  if offsetIndex = 0 set offsetIndex = 1
  
  for i=offsetIndex:1:..Behaviors.Count() {
    set behavior = ..Behaviors.GetAt(i)
    do behavior.GetState().GetArguments(.recordedArgs)

    if ##class(Wireframe.Core.Helpers).ArgumentCompare(.args, .recordedArgs) {
      return i
    }
  }

  return 0
}

Method GetBehaviorsList() As %ListOfObjects
{
  return ..Behaviors
}

Method Begin(args...) As Wireframe.Core.AbstractBehavior
{
  do ..Coordinator.SetRecorder($this)
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

Method ResetTrackingIndex()
{
  set ..BehaviorIndex = 0
}

}

