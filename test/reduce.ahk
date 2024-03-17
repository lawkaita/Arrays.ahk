class Reduce_Tests {
  Begin() {
    fn_acc(&calls, acc, cur) {
      calls++
      return acc + cur
    }
    this.fn_acc := fn_acc
  }
  Test_Empty_Array_No_Initial() {
    ; in js this throws TypeError
    res := [].reduce((acc,cur) => (acc+cur))
    YUnit.assert(res == 0)
  }
  Test_Empty_Array_With_Initial() {
    fn_acc := this.fn_acc
    calls := 0
    fb := fn_acc.bind(&calls)
    YUnit.assert([].reduce(fb, 3) == 3)
    YUnit.assert(calls == 0)
  }
  Test_Onetuple_Array_No_Initial() {
    fn_acc := this.fn_acc
    calls := 0
    fb := fn_acc.bind(&calls)
    YUnit.assert([3].reduce(fb) == 3)
    YUnit.assert(calls == 0)
  }
  Test_Onetuple_Array_With_Initial() {
    fn_acc := this.fn_acc
    calls := 0
    fb := fn_acc.bind(&calls)

    YUnit.assert([3].reduce(fb, 3) == 6)
    YUnit.assert(calls == 1)
  }
  Test_Summign_No_Initial() {
    fn_acc := this.fn_acc
    calls := 0
    fb := fn_acc.bind(&calls)
    YUnit.assert([1,2,3,4].reduce(fb) == 10)
  }
  Test_Summign_With_Initial() {
    fn_acc := this.fn_acc
    calls := 0
    fb := fn_acc.bind(&calls)
    YUnit.assert([1,2,3,4].reduce(fb, 1) == 11)
  }
  Test_All_Truthy() {
    both := (x, y) => (x and y)
    trues := [ 1, 2, true, 'abc', {}, [], Error ]
    all_truthy := trues.reduce(both)
    YUnit.assert(all_truthy)
    trues.push('')
    all_truthy := trues.reduce(both)
    YUnit.assert(not all_truthy)
  }

}
