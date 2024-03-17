class ForEach_Tests {
  Test_ForEach_Empty_Array() {
    calls := 0
    fn := (&x) => (x++)
    fb := fn.bind(&calls)
    arr := []
    ; [].forEach(fb)  ; A_AhkVersion 2.0.11: Error: This line does not contain a recognized action.
    arr.forEach(fb)
    YUnit.assert(calls == 0)
  }
  Test_ForEach_Onetuple_Array() {
    calls := 0
    fn := (&x) => (x++)
    fb := fn.bind(&calls)
    arr := ['a']
    arr.forEach(fb)
    YUnit.assert(calls == 1)
  }
  Test_ForEach_ThreeTuple_Array() {
    calls := 0
    fn := (&x) => (x++)
    fb := fn.bind(&calls)
    arr := ['a', 'b', 'c']
    arr.forEach(fb)
    YUnit.assert(calls == 3)
  }
  Test_ThrowsError() {
    arr := [1,2,3]
    fn_ThrowError(x) {
      Throw Error('An Error')
    }
    fn := (arr, f) => (arr.forEach(f)) 
    fb := fn.bind(arr, fn_ThrowError)
    YUnit.assert(ThrowsError(['Error', 'An Error'], fb))
  }
}
All_Tests.push(ForEach_Tests)
