Class Wireframe.Core.BridgeConsolidator Extends %RegisteredObject
{

Property BehaviorBridge As Wireframe.Core.BehaviorBridge [ Private ];

Property ExpectationBridge As Wireframe.Core.ExpectationBridge [ Private ];

Method SetAndReturnBehaviorBridge(behaviorBridge As Wireframe.Core.BehaviorBridge) As Wireframe.Core.BehaviorBridge
{
  set ..BehaviorBridge = behaviorBridge
  do ..BehaviorBridge.SetConsolidator($this)
  
  return ..BehaviorBridge
}

Method SetAndReturnExpectationBridge(expectationBridge As Wireframe.Core.ExpectationBridge) As Wireframe.Core.ExpectationBridge
{
  set ..ExpectationBridge = expectationBridge
  do ..ExpectationBridge.SetConsolidator($this)
  
  return ..ExpectationBridge
}

Method GetNextBehavior(methodName As %String, args...) As Wireframe.Core.AbstractBehaviorState
{
  if $isobject(..ExpectationBridge) {  
    set expectedBehaviorState = ..ExpectationBridge.GetCoordinator().GetNextBehavior(methodName, args...)  
    if $isobject(expectedBehaviorState) return expectedBehaviorState
  }
  
  if $isobject(..BehaviorBridge) {
    set stubbedBehaviorState = ..BehaviorBridge.GetCoordinator().GetNextBehavior(methodName, args...)  
    if $isobject(stubbedBehaviorState) return stubbedBehaviorState
  }
    
  return ""
}

Method Reset(methodName As %String)
{
  if $isobject(..ExpectationBridge) {  
    do ..ExpectationBridge.GetCoordinator().Reset(methodName)
  }
  
  if $isobject(..BehaviorBridge) {
    do ..BehaviorBridge.GetCoordinator().Reset(methodName)
  }
}

Method Clear(methodName As %String)
{
  if $isobject(..ExpectationBridge) {  
    do ..ExpectationBridge.GetCoordinator().Clear(methodName)
  }
  
  if $isobject(..BehaviorBridge) {
    do ..BehaviorBridge.GetCoordinator().Clear(methodName)
  }
}

Method AssertMethodIsNotStubbed(methodName As %String)
{
  
  set methodIsStubbed = ..IsMethodStubbed(methodName)
  
  if methodIsStubbed {
    $$$ThrowStatus($$$ERROR($$$GeneralError, $$$FormatText("Method '%1' is already mocked and cannot be stubbed.", methodName)))
  }
}

Method AssertMethodIsNotMocked(methodName As %String)
{
  
  set methodIsMocked = ..IsMethodMocked(methodName)
  
  if methodIsMocked {
    $$$ThrowStatus($$$ERROR($$$GeneralError, $$$FormatText("Method '%1' is already stubbed and cannot be mocked.", methodName)))
  }
}

Method IsMethodMocked(methodName As %String) As %Boolean
{
  if '$isobject(..ExpectationBridge) return 0
  
  return ..ExpectationBridge.GetCoordinator().HasMethodRecorder(methodName)
}

Method IsMethodStubbed(methodName As %String) As %Boolean
{
  if '$isobject(..BehaviorBridge) return 0
  
  return ..BehaviorBridge.GetCoordinator().HasMethodRecorder(methodName)
}

}

