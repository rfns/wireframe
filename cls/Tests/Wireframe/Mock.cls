Class Tests.Wireframe.Mock
{

ClassMethod T()
{
  set mock = ##class(Wireframe.Mock).%New()
  set verifier = mock.GetVerifier()
  set arg = mock.GetArgumentMatcher()
  
  do mock.Expect().ATest(arg.AnyOf("%ListOfDataTypes")).Exactly(1).AndReturn(1)
  do mock.Expect().AndAnotherTest(1).AtLeast(3).AndReturn(10)
  
  write mock.GetObject().ATest(1)
  write mock.GetObject().ATest(1)
  write mock.GetObject().AndAnotherTest(1)
  write mock.GetObject().AndAnotherTest(1)
  
  do $System.OBJ.DisplayError(verifier.Verify())

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
  
  do verifier.Verify()
}

ClassMethod T2()
{
  set list = ##class(%ListOfDataTypes).%New()
  set spy = ##class(Wireframe.Spy).%New(list)

  w spy.Insert(1)

  w spy.Count()
}

}

