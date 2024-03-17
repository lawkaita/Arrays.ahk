Class Arrays_Tests {
  Test_Arrays_Variadic_Call() {
  }
  Test_Arrays_Variadic_Call_Can_Throw_Error_From_Bound_Func() {
    fn_ThrowError(x) {
      Throw TypeError('A TypeError')
    }
    fx := fn_ThrowError.bind(1)

    fn := (f) => (Arrays._variadic_call(f, unset, 1, 2, 3, 4))
    fb := fn.bind(fx)
    YUnit.assert(ThrowsError(['TypeError', 'A TypeError'], fb))

    /*
      _variadic_call eats fn_ThrowsError as implicit this:
    */
    YUnit.assert(ThrowsError(["Error", "Missing a required parameter.", "", "fn"], Arrays._variadic_call, fn_ThrowError))  

    a_vc := Arrays._variadic_call.bind(Arrays)  ;  bind for implicit this

    /*
      A) fn_ThrowError is not BoundFunc or fn_ThrowError.variadic == false
      B) fn_ThrowError.maxParams == 1
      C) _variadic_call(fn_ThrowError) with no args causes 'l' to be of length 0,
      but _variadic_call tries to call fn(l[1]) since (B)

      Update: now _variadic_call increases l.length to 1, with l[1] as unset,
      calling fn(l*) which evaluates to fn(unset)
    */
    YUnit.assert(not ThrowsError([IndexError, "Invalid index.", "Array.Prototype.__Item.Get", "1"], a_vc, fn_ThrowError))
    YUnit.assert(ThrowsError(Error("Missing a required parameter.", "", "x"), a_vc, fn_ThrowError))

    YUnit.assert(ThrowsError(Error, a_vc, fx))
    YUnit.assert(ThrowsError([TypeError, 'A TypeError'], a_vc, fx))
  }
  Test_Arrays_Variadic_Call_Too_Many_Args() {
    fn_sixArgs(a1,a2,a3,a4,a5,a6) {
      return
    }
    fn_fiveArgs := fn_sixArgs.bind(1)
    fn := (f) => (Arrays._variadic_call(f))
    fb := fn.bind(fn_fiveArgs)
    YUnit.assert(ThrowsError(Error, fb))
  }
  Test_Normalize_Starting_Bound() {
    YUnit.assert(Arrays._normalize_starting_bound([1,1,1], 2, true) == 2)
    YUnit.assert(Arrays._normalize_starting_bound([1,1,1], 2, false) == 2)

    YUnit.assert(Arrays._normalize_starting_bound([1,1,1], 4, true) == 0)
    YUnit.assert(Arrays._normalize_starting_bound([1,1,1], 4, false) == 3)

    YUnit.assert(Arrays._normalize_starting_bound([1,1,1], -1, true) == 3)
    YUnit.assert(Arrays._normalize_starting_bound([1,1,1], -1, false) == 3)

    YUnit.assert(Arrays._normalize_starting_bound([1,1,1], -4, true) == 1)
    YUnit.assert(Arrays._normalize_starting_bound([1,1,1], -4, false) == 0)
  }
}
All_Tests.push(Arrays_Tests)
