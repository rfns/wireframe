Class Tests.Wireframe.Mock
{

ClassMethod T()
{
  set mock = ##class(Wireframe.Mock).%New()
  set arg = mock.GetArgumentMatcher()

  do mock.When().OneTest(arg.ByAET({ "id": [1,2,3] })).ThenReturn(5)
  do mock.When().OneTest(arg.AnyOf("%ListOfDataTypes")).ThenReturn(4)
  do mock.When().AnotherTest(1, arg.ByRef(), 2, arg.Any()).ThenThrow(##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError, "uh...")))
  do mock.When().OneTest(2).ThenReturn(6,7,8)

  set object = mock.GetObject()

  set a(1) = 1

  write object.OneTest({ "id": [1,2,3] })

  write object.OneTest(##class(%ListOfDataTypes).%New())

  write object.OneTest(2)
  write object.OneTest(2)
  write object.OneTest(2)

  write object.AnotherTest(1, .a, 2, "")
}

ClassMethod T2()
{
  set list = ##class(%ListOfDataTypes).%New()
  set spy = ##class(Wireframe.Spy).%New(list)

  w spy.Insert(1)

  w spy.Count()
}

}

