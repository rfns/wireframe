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

Method GetNextBehavior(methodName As %String, args...) As Wireframe.Core.BehaviorState
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

Method AssertMethodIsNotStubbed(methodName As %String)
{
  if '$isobject(..BehaviorBridge) return 
  
  set methodIsStubbed = ..BehaviorBridge.GetCoordinator().HasMethodRecorder(methodName)
  
  if methodIsStubbed {
    $$$ThrowStatus($$$ERROR($$$GeneralError, $$$FormatText("Method '%1' is already mocked and cannot be stubbed.", methodName)))
  }
}

Method AssertMethodIsNotMocked(methodName As %String)
{
  if '$isobject(..ExpectationBridge) return
  
  set methodIsMocked = ..ExpectationBridge.GetCoordinator().HasMethodRecorder(methodName)
  
  if methodIsMocked {
    $$$ThrowStatus($$$ERROR($$$GeneralError, $$$FormatText("Method '%1' is already stubbed and cannot be mocked.", methodName)))
  }
}

}

