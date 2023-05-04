Class Wireframe.Core.Stub Extends (%RegisteredObject, Wireframe.Core.AbstractTestDouble)
{

Method OnSetBridge(consolidator As Wireframe.Core.BridgeConsolidator) As Wireframe.Core.BehaviorBridge [ Private ]
{
    
  return consolidator.SetAndReturnBehaviorBridge(
    ##class(Wireframe.Core.BehaviorBridge).%New()
  )
}

Method UseFromMockFactory(mockFactory As Wireframe.Mock) [ Internal ]
{
  do ..SetConsolidator(mockFactory.GetConsolidator())
}

}

