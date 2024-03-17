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
    YUnit.assert(res == "")
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
    YUnit.assert(calls == 3)
  }
  Test_Summign_With_Initial() {
    fn_acc := this.fn_acc
    calls := 0
    fb := fn_acc.bind(&calls)
    YUnit.assert([1,2,3,4].reduce(fb, 1) == 11)
    YUnit.assert(calls == 4)
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
  Test_Maxmimum() {
    values := [1,2,3,4,2,0,1,3]
    res := values.reduce((x,y) => max(x,y))
    YUnit.assert(res == 4)
  }
  Test_Concat() {
    arr := [1,2,3,4,5]
    res := arr.reduce((x,y) => (x . y))
    YUnit.assert(res == "12345")
  }
}
All_Tests.push(Reduce_Tests)
