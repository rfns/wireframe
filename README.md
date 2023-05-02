# Wireframe

A mock framework with fluent API for Caché, partially based on NSubstitute.

## The framework API

With the exception of the spy, The framework API can be accessed __before__ calling `When()` and `Expect()` methods. Right after the instance is constructed.

* `%New(className?, constructorArgs?...)`: Constructs the mock API, passing the `className` and `constructorArgs` will instantiate, replay and copy the state of the real object back to the mock.
* * `When()`: Returns a bridge to the stub fluent API.
* * `Expect()`: Returns a bridge to the mock (the test double) fluent API.
* * `GetArgumentMatcher()`: Returns an _argument matcher_ that can be used for generic validations.
* * * `Any()`: Creates an argument matcher that accepts an argument of any nature.
* * * `AnyOf(classType)`: Creates an argument matcher that accepts an instance of `classType` or a data type of kind.
* * * `ByRef()`: Creates an argument that accepts an argument passed by reference.
* * * `ByAET(aet)`: Creates an argument that accepts an argument which matches the dynamic structure.
* * * `Is(value)`: Creates an argument that accepts exactly the `value`. This is actually an implicit matcher for each argument that don't use any of the other matchers.
* * `GetObject()`: This is actually a spy linked to a mock or stub. So it returns an object with the Spy API.
* * `GetVerifier()`: Returns an _unordered_ verifier that can be employed to verify whether the expectations set by the test were met.
* * `Verify()`: Validates and returns an status based on meeting or not the expectations. This will also call `Reset()`.
* * `VerifyOnly(methodName?)`: Same as `Verify` but this won't call `Reset()`. Useful if you want to replay the validation for debugging purposes. Passing `methodName` will restrict the validation that method only.
* * `GerOrderedVerifier()` is about the same as `GetVerifier`, but this one takes in account the order of execution inside the SUT against the order of the expectations that were defined by the test.
* * * `Verify()`: Validates and returns n status based on meeting or not the expectations. This will also call `Reset()`.
* * * `VerifyOnly(methodName?)`: Same as `Verify` but this won't call `Reset()`. Useful if you want to replay the validation for debugging purposes. Passing `methodName` will restrict the validation that method only.
* * `Reset()`: Resets the test doubles to a pristine state. Calling a previously stubbed method as well as attempting to verify the mock, will throw an exception.

## Test double: Stub

Created by calling the method `When()`. The stub API is composed by the following methods.

* `<DynamicMethod>(expectedArguments...)`: The method you're expecting to define a behavior for, the preconditions for calling `ThenReturn` or `ThenThrow` are defined through the arguments you provide here.

* * `ThenReturn(valuesToReturn...)`: A set of values which the test is providing through. Each value you provide is returned on each call made __sequentially__. This is actually a shortcut for `When().<DynamicMethod>(sameargs...).ThenReturn(nextValueToReturn)`.

* * `ThenThrow(exceptionsToThrow...)`: the same as `ThenReturn` but for exceptions. Keep in mind that you're expected to catch these exceptions in the SUT.

### Example

```objectscript
  set stub = ##class(Wireframe.Mock).%New()
  set arg = stub.GetArgumentMatcher()

  set exception = ##class(%Exception.StatusException).CreateFromStatus(
    $$$ERROR($$$GeneralError, "Divide by zero is not a valid operation.")
  )

  do stub.When().Sum(1,2).ThenReturn(3)
  do stub.When().Multiply(10,5).ThenReturn(50)
  do stub.When().Divide(arg.AnyOf("%Float"), 0).ThenThrow(exception)

  set object = stub.GetObject()

  write object.Sum(1,2) // 3
  write object.Multiply(10,5) // 50
  write object.Divide(10,0) // <THROW>

  do stub.Reset()
```

## Test double: Mock

Created by calling the `Expect()` method. The mock API is composed by the following methods:

* `<DynamicMethod>(expectedArguments...)`: Same as stub.

* * `AndReturn(valuesToReturn...)`: Same as `ThenReturn`.

* * `AndThrow(exceptionsToThrow...)`: Same as `ThenThrow`.

* * `Exactly(nCalls)`: When set, you expect this method to be called exactly `nCalls` times.

* * `AtLeast(nCalls)`: When set, you expect this method to be called at least `nCalls` times.

* * `AtLeast(nCalls)`: When set, you expect this method to be called at most `nCalls` times.

### Example

```objectscript
  set httpClientMock = ##class(Wireframe.Mock).%New()
  set verifier = httpClientMock.GetVerifier()
  set arg = httpClientMock.GetArgumentMatcher()

  do httpClientMock.Expect().Put("/my/api/1").Exactly(1)
  do httpClientMock.Expect().Post(arg.AnyOf("%String"), arg.AnyOf("%DynamicAbstractObject"))
  do httpClientMock.Expect().Get(arg.AnyOf("%String")).AtMost(2).ThenReturn({
    "http_status": 200,
    "response": {
      "data": "blah blah blah"
    }
  })

  set object = stub.GetObject()

  write object.Put("/my/api/1")
  write object.Post("my/unspecified/resource", { "some_data": true })
  write object.Get("my/unspecified/resource")
  write object.Get("my/unspecified/resource")

  do $$$AssertStatusOK(verifier.Verify())
```

## Test double: Spy

DIfferent from _mocks_ and _stubs_. An **indepent** spy is always created by the constructor, which can optionally receive an __object__.

```objectscript
  set object = ##class(Wireframe.Spy).%New()
  do object.Booh()

  write object.ForMethod("booh").CallCount // 1
```

* `ForMethod(methodName)`: Returns an instance of the method logger for `methodName`.
* * `LastUsedArguments`: Holds a MultiDimensional of the arguments that `methodName` received last time.
* * `LastException`: Holds an instance of an exception that `methodName` threw last time.
* * `LastReturnedValue`: Holds the value that `methodName` returned last time.
* * `CallCount`: The amount of times that `methodName` has been called regardless of arguments.
* * `Calls(n)`: A MultiDimensional that holds every call method to `methodName`.
* * * `ExceptionThrown`: Holds an instance of the exception threw at call `n`.
* * * `ReturnedValue`: Holds the value returned by the method `methodName` at call `n`.
* `ForProperty(propertyName)`: Returns an instance of the property logger for `propertyName`.
* * `GetCount`: Holds an integer that keeps track on how many times `propertyName`'s getter has been called.
* * `SetCount`: Holds an integer that keeps track on how many times `propertyName`'s setter has been called.
* * `Sets(n)` Holds a MultiDimensional that keeps track of the value set to `propertyName` when the setter was called at `n` times.
* * `Sets(n)` Holds a MultiDimensional that keeps track of the value returned by `propertyName` when the setter was called at `n` times.

## Argument matchers

Argument matchers are a type of placeholder for arguments. There'll be some cases where the system under test might be returning a value or reference that changes everytime.

While using a defined argument would cause the test to fail. These placeholders allows the preconditions of the mock/stub to be fullfilled using specific rules defined by the matcher.

e.g. Let's say you want to ensure a method is receving a correct type of input from the SUT. Notice that
$horolog is a special variable that holds a different value everytime it's called so __you cannnot test the value.__

```objectscript
ClassMethod RunSomeLongOperation()
{
  set start = $piece($horolog, ",", 2)

  do ..LogService.Log(start, "Operation started")

  // The operation code.

  set end = $piece($horolog, ",", 2)

  do ..LogService.Log(end, "Operation ended")
}
```

As you can see in the example above, in order to fullfill the preconditions, we can use an argument matcher.

That is, by **not** providing a value to it, but instead a type through `AnyType`, this matcher calls the `IsValid` method from `%Time` to validate if the
input received is a valid time.

Since the second part of $horolog is represented by the `%Time` class, having the matcher validate it through its class type method is still essential.

```objectscript
  set logServiceMock = ##class(Wireframe.Mock).%New()
  set arg = logService.GetArgumentMatcher()

  do logServiceMock.Expect().Log(arg.AnyOf("%Time"), "Operation started").Exactly(1)
  do logServiceMock.Expect().Log(arg.AnyOf("%Time"), "Operation ended").Exactly(1)

  set logService = logServiceMock.GetObject()

  set sut = ##class(My.Operation.Class).%New(logService)

  do sut.RunSomeLongOperation()

  do $$$AssertStatusOK(sut.RunSomeLogOperation())
```

## Verifiers

Verifiers are bult-in services that evaluate the received value against the expectation defined by the test. You can use the output of a verifier combining it with an assertion.

By nature verifiers provide a very clear description of the error that caused the test to fail.

# Example

```objectscript
  set mock = ##class(Wireframe.Mock).%New()
  set verifier = mock.GetVerifier()

  do mock.CallMe().Exactly(1)

  do $$$AssertStatusOK(verifier.Verify()) // fails, because CallMe was not called exactly 1 times.
```
