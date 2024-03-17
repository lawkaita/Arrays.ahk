#requires autohotkey v2.0
#SingleInstance Force

#Include <v2/YUnit-2/Yunit>
#Include <v2/YUnit-2/Window>
#Include <v2/YUnit-2/StdOut>
#Include <v2/conio>

/*
#Include "util.ahk"
debug := {}
debug.ThrowsError := true
*/
#Include <v2/throwsError/ThrowsError>

Conio.init("wt").SetWinPosTopRight().setQuotePrint(false)

pid := ProcessExist()
#HotIf WinGetPid("A") == pid
Esc::ExitApp
^Enter::Reload
#HotIf

#include "Arrays_apply.ahk"
#include "Arrays_todo.ahk"

All_Tests := []

#include "test"
#include "equals.ahk"
#include "map.ahk"
#include "filter.ahk"
#include "reduce.ahk"
#include "reduceRight.ahk"
#include "forEach.ahk"
#include "join.ahk"
#include "every.ahk"
#include "slice.ahk"
;#include "slice.node.ahk"
#include "toString.ahk"
#include "splice.ahk"
#include "indexOf.ahk"
#include "lastIndexOf.ahk"
#include "fill.ahk"
#include "sort.ahk"
#include "concat.ahk"
#include "fromEnumerator.ahk"
#include "flat.ahk"
#include "flatMap.ahk"
#include "copyWithin.ahk"
;#include "find.ahk"
;#include "findLast.ahk"
#include "findIndex.ahk"
#include "includes.ahk"
#include "reverse.ahk"
#include "unshift.ahk"
#include "entries.ahk"

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

    YUnit.assert(ThrowsError([Error], Arrays._variadic_call, fn_ThrowError, fn_ThrowError, 1))
      ;.and(r => (conio.println('>>>' StrSplit(r.error.stack, '`n')[2]))))
      ;.and(r => (conio.println('>>>' type(r.error))))) ;r.error.stack))))
      ;.and(r => (conio.println('>>>' r.error.extra))))
      ;.and(r => (conio.println('>>>' r.error.message))))

    /*
    YUnit.assert(ThrowsError([PropertyError], Arrays._variadic_call, fx, 1, 2, 3, 4).and(r => (conio.println(r.error.message))))
    YUnit.assert(ThrowsError([PropertyError], Arrays._variadic_call, fx, 1, 2, 3, 4).and(r => (conio.println(r.error.what))))
    YUnit.assert(ThrowsError([PropertyError], Arrays._variadic_call, fx, 1, 2, 3, 4).and(r => (conio.println(r.error.extra))))
    YUnit.assert(ThrowsError([PropertyError], Arrays._variadic_call, fx, 1, 2, 3, 4))
    */
    r := ThrowsError(Error, Arrays._variadic_call, fx, fx)
    ;conio.println(r.error.message)
    ;conio.println(r.error.stack)
    ;conio.println(r.fn.name)
    
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
  Test_Positive_Index_Of() {
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

; include last
#include "_end.ahk"


fn_test_todo() {
  test_names := All_Tests.map( x => x.prototype.__class )
  for i, sym in js_array_prototype_symbols {
    subs := StrSplit(sym, ['.', '()'])
    method := subs[3] ? subs[3] : subs[2]
    arr := []
    test_name := method . "_Tests"
    if not Arrays.hasMethod(method) {
      conio.println("Arrays (" i "): " method)
    }
    if not arr.hasMethod(method) {
      conio.println("[] (" i "): " method)
    }
    if not test_names.findIndex(x => x = test_name) {
      conio.println("missing tests: " test_name)
    }
  }
}
fn_test_todo()

Yunit.Use(YunitWindow).Test(All_Tests*)

