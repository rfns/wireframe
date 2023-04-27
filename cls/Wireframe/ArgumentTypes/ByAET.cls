Class Wireframe.ArgumentTypes.ByAET Extends (%RegisteredObject, Wireframe.Core.MatchableArgument)
{

Property ExpectedPayload As %DynamicObject [ Private ];

Method %OnNew(expectedPayload As %DynamicObject) As %Status
{
  set ..ExpectedPayload = expectedPayload
  return $$$OK
}

Method Match(input) As %Boolean
{
  if '$isobject(input) || 'input.%Extends("%DynamicAbstractObject") {
    return 0
  }

  return $$DeepCompare(input, ..ExpectedPayload)

DeepCompare(payload="", expectedPayload)
  set iterator = payload.%GetIterator()

  if payload.%Size() '= expectedPayload.%Size() {
    return 0
  }

  while iterator.%GetNext(.key, .value) {
    if $isobject(value) && value.%Extends("%DynamicAbstractObject") {
      set childObject = $property(expectedPayload, key)
      if '$$DeepCompare(value, childObject) return 0
    }

    set expectedValue = $property(payload, key)

    if expectedValue '= value {
      return 0
    }
  }

  return 1
}

}

