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
}
