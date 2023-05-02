Class Tests.Wireframe.Mock
{

ClassMethod T()
{
  set mock = ##class(Wireframe.Mock).%New()
  set verifier = mock.GetOrderedVerifier()
  set arg = mock.GetArgumentMatcher()
  
  do mock.Expect().ATest(arg.AnyOf("%ListOfDataTypes")).AndReturn(1)
  do mock.Expect().AndAnotherTest(1).AtLeast(3).AndReturn(10)
    
  write mock.GetObject().AndAnotherTest(1)  
  write mock.GetObject().AndAnotherTest(1)
  write mock.GetObject().ATest(##class(%ListOfDataTypes).%New())
  write mock.GetObject().AndAnotherTest(1)
  // write mock.GetObject().ATest(##class(%ListOfDataTypes).%New())
  
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

ClassMethod T3()
{
  set mock = ##class(Wireframe.Mock).%New()
  set arg = mock.GetArgumentMatcher()
  
  do mock.When().ICalledYou(arg.AnyOf("%Integer")).ThenReturn(10, 20, 30)
  
  set obj = mock.GetObject()
  
  write obj.ICalledYou(10)
  write obj.ICalledYou("aaa")
  write obj.ICalledYou(20)
  write obj.ICalledYou(30)
}

}

