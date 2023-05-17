Class Wireframe.Core.AbstractCoordinator [ Abstract ]
{

Property Recorders As array Of Wireframe.Core.BehaviorRecorder [ Private ];

Method SetRecorder(recorder As Wireframe.Core.BehaviorRecorder) [ Final ]
{
  set name = recorder.GetMethodName()

  if '..Recorders.IsDefined(name) {
    do ..Recorders.SetAt(recorder, name)
  }
}

Method SetupRecorder(methodName As %String) As Wireframe.Core.BehaviorRecorder [ Final ]
{
 
  set recorder = ..Recorders.GetAt(methodName)
  if $isobject(recorder) return recorder
  
  set recorder = ..OnSetupRecorder(methodName)
  
  do recorder.SetMethodName(methodName)  
  do ..SetRecorder(recorder)
  
  return recorder
}

Method OnSetupRecorder(methodName As %String) As Wireframe.Core.BehaviorRecorder [ Abstract, Private ]
{
  $$$ThrowStatus($$$ERROR($$$MethodNotImplemented, "OnSetupRecorder"))
}

Method OnBehaviorSet(behavior As Wireframe.Core.AbstractBehavior)
{
}

Method GetNextBehavior(methodName As %String, args...) As Wireframe.Core.AbstractBehaviorState
{
  set recorder = ..Recorders.GetAt(methodName)
  set behavior = ""
  
  if $isobject(recorder) {
    set behavior = recorder.GetNextBehavior(args...)  
  }   
  
  return ..OnGetNextBehavior(behavior, methodName, args...)
}

Method OnGetNextBehavior() As Wireframe.Core.AbstractBehaviorState [ Abstract, Private ]
{
  $$$ThrowStatus($$$ERROR($$$MethodNotImplemented, "OnGetNextBehavior"))
}

Method Reset(methodName As %String)
{
  if methodName '= "" {
    do ..Recorders.GetAt(methodName).ResetTrackingIndex()
    return
  }
  
  set name = ""
  
  for {
    set recorder = ..Recorders.GetNext(.name)
    if '$isobject(recorder) return
    
    do recorder.ResetTrackingIndex()  
  }
}

Method Clear(methodName As %String)
{
  if methodName '= "" do ..Recorders.RemoveAt(methodName)
  else  do ..Recorders.Clear()
}

Method HasMethodRecorder(methodName As %String)
{
  return ..Recorders.IsDefined(methodName)
}

}

