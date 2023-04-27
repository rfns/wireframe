Class Wireframe.Core.PropertyLogger Extends %RegisteredObject
{

Property GetCount As %Integer [ InitialExpression = 0, ReadOnly ];

Property SetCount As %Integer [ InitialExpression = 0, ReadOnly ];

Property Sets [ MultiDimensional, ReadOnly ];

Property Gets [ MultiDimensional, ReadOnly ];

Property LastSetValue [ ReadOnly ];

Property LastGetValue;

Method IncreaseGetCount()
{
  set i%GetCount = ..GetCount + 1
}

Method IncreaseSetCount()
{
  set i%SetCount = ..SetCount + 1
}

Method RecordSetOperation(value As %String)
{
  if i%LastSetValue = value  return
  do ..IncreaseSetCount()

  set i%LastSetValue = value
  set i%Sets(..SetCount) = value
}

Method RecordGetOperation(value As %String)
{

  do ..IncreaseGetCount()

  set i%LastGetValue = value
  set i%Gets(..GetCount) = value
}

}

