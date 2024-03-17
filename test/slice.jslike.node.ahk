class Slice_Node_Tests {
  Begin() {
   
    this.shell := ComObject("WScript.Shell")
    this.bash := "C:\Windows\System32\bash.exe"
    this.arrToJs := (this, arr) => Format('[{}]', arr.join())
    this.eval := (this, s) => (this.shell.exec(
      Format("{} -c `"node -e 'process.stdout.write({})'`""
        , this.bash
        , s
      )).stdOut.ReadAll()
    )
    this.slice  := (this, a, b, arr) => (this.eval(Format('{}.slice({},{}).join()', this.arrToJs(arr), a, b)))
    this.yields := (this, a, b, arr, res) => (this.slice(a, b, arr) == res.join())

  }
  Test_Eval() {
    YUnit.assert(this.eval('[1,2,3].join()') == '1,2,3')
    YUnit.assert(this.slice(0,2, [1,2,3,4]) == [1,2].join())
    YUnit.assert(this.yields(0,2, [1,2,3,4], [1,2]))
  }
  Test_Slice_Same_Start_End() {
    for i in [1,2,3,4] {
      YUnit.assert([1,2,3,4].slice(i,i).equals([i]))
      YUnit.assert(this.slice(i-1, i, [1,2,3,4]) == [i].join())
      YUnit.assert(this.yields(i-1, i, [1,2,3,4], [i]))
    }
  }
  Test_Zero_Means_Last() {
    arr := [1,2,3,4]
    expected := [4]
    res := arr.slice(0,0)
    YUnit.assert(res.equals(expected))
    res := arr.slice(0)
    YUnit.assert(res.equals(expected))
  }
  Test_Increasing_Start() {
    arr := [1,2,3,4]
    
    /*
    conio.println(this.slice(-6, arr.length, arr))
    YUnit.assert(this.yields(-6, arr.length, arr, arr))
    */
    test_settings := [
      {a:-5, arr:arr, expected:[1,2,3,4]},
      {a:-4, arr:arr, expected:[1,2,3,4]},
      {a:-3, arr:arr, expected:[1,2,3,4]},
      {a:-2, arr:arr, expected:[2,3,4]},
      {a:-1, arr:arr, expected:[3,4]},
      {a:0, arr:arr, expected:[4]},
      {a:1, arr:arr, expected:[1,2,3,4]},
      {a:2, arr:arr, expected:[2,3,4]},
      {a:3, arr:arr, expected:[3,4]},
      {a:4, arr:arr, expected:[4]},
      {a:5, arr:arr, expected:[]},

      {a:-5, b:3, arr:arr, expected:[1,2,3]},
      {a:-4, b:3, arr:arr, expected:[1,2,3]},
      {a:-3, b:3, arr:arr, expected:[1,2,3]},
      {a:-2, b:3, arr:arr, expected:[2,3]},
      {a:-1, b:3, arr:arr, expected:[3]},
      {a:0, b:3, arr:arr, expected:[]},
      {a:1, b:3, arr:arr, expected:[1,2,3]},
      {a:2, b:3, arr:arr, expected:[2,3]},
      {a:3, b:3, arr:arr, expected:[3]},
      {a:4, b:3, arr:arr, expected:[]},
      {a:5, b:3, arr:arr, expected:[]},

      {a:-5, b:2, arr:arr, expected:[1,2]},
      {a:-4, b:2, arr:arr, expected:[1,2]},
      {a:-3, b:2, arr:arr, expected:[1,2]},
      {a:-2, b:2, arr:arr, expected:[2]},
      {a:-1, b:2, arr:arr, expected:[]},
      {a:0, b:2, arr:arr, expected:[]},
      {a:1, b:2, arr:arr, expected:[1,2]},
      {a:2, b:2, arr:arr, expected:[2]},
      {a:3, b:2, arr:arr, expected:[]},
      {a:4, b:2, arr:arr, expected:[]},
      {a:5, b:2, arr:arr, expected:[]}
    ]
    h := (t,n) => (t.hasOwnProp(n))
    for t in test_settings {
      YUnit.assert(t.arr.slice(
          h(t,'a') ? t.a : unset
        , h(t,'b') ? t.b : unset
      ).equals(t.expected))
      YUnit.assert(this.yields(
          h(t,'a') ? t.a-1 : 0
        , h(t,'b') ? t.b   : t.arr.length 
        , t.arr
        , t.expected
      ))
    }
  }
  Test_Decreasing_End() {
    arr := [1,2,3,4]
    test_settings := [
      {b: 5, arr: arr, expected: [1,2,3,4]},
      {b: 4, arr: arr, expected: [1,2,3,4]},
      {b: 3, arr: arr, expected: [1,2,3]},
      {b: 2, arr: arr, expected: [1,2]},
      {b: 1, arr: arr, expected: [1]},
      {b: 0, arr: arr, expected: [1,2,3,4]},
      {b: -1, arr: arr, expected: [1,2,3]},
      {b: -2, arr: arr, expected: [1,2]},
      {b: -3, arr: arr, expected: [1]},
      {b: -4, arr: arr, expected: []},
      {b: -5, arr: arr, expected: []},

      {a: 2, b: 5, arr: arr, expected: [2,3,4]},
      {a: 2, b: 4, arr: arr, expected: [2,3,4]},
      {a: 2, b: 3, arr: arr, expected: [2,3]},
      {a: 2, b: 2, arr: arr, expected: [2]},
      {a: 2, b: 1, arr: arr, expected: []},
      {a: 2, b: 0, arr: arr, expected: [2,3,4]},
      {a: 2, b: -1, arr: arr, expected: [2,3]},
      {a: 2, b: -2, arr: arr, expected: [2]},
      {a: 2, b: -3, arr: arr, expected: []},
      {a: 2, b: -4, arr: arr, expected: []},
      {a: 2, b: -5, arr: arr, expected: []},

      {a: 3, b: 5, arr: arr, expected: [3,4]},
      {a: 3, b: 4, arr: arr, expected: [3,4]},
      {a: 3, b: 3, arr: arr, expected: [3]},
      {a: 3, b: 2, arr: arr, expected: []},
      {a: 3, b: 1, arr: arr, expected: []},
      {a: 3, b: 0, arr: arr, expected: [3,4]},
      {a: 3, b: -1, arr: arr, expected: [3]},
      {a: 3, b: -2, arr: arr, expected: []},
      {a: 3, b: -3, arr: arr, expected: []},
      {a: 3, b: -4, arr: arr, expected: []},
      {a: 3, b: -5, arr: arr, expected: []}
    ]
    h := (t,n) => (t.hasOwnProp(n))
    for t in test_settings {
      YUnit.assert(t.arr.slice(
          h(t,'a') ? t.a : unset
        , h(t,'b') ? t.b : unset
      ).equals(t.expected))

      ahk_a := h(t,'a') ? t.a : 1
      ahk_b := h(t,'b') ? t.b : arr.length
      js_a := h(t,'a') ? t.a-1 : 0
      js_b := h(t,'b') ? (t.b == 0 ? t.arr.length : t.b) : t.arr.length 

      js_slice := this.slice(
          js_a
        , js_b
        , t.arr)

      conio.println(Format("ahk_a: '{1}', ahk_b: '{2}', ahk_result: '{3}'"
          , ahk_a
          , ahk_b
          , t.arr.slice(ahk_a, ahk_b).join()))
      conio.println(Format("js_a:  '{1}', js_b:  '{2}', js_result:  '{3}'"
          , js_a
          , js_b
          , js_slice))

      YUnit.assert(this.yields(
            js_a
          , js_b
	  , t.arr
	  , t.expected)
        , Format("a: '{1}', b: '{2}', expected: '{3}', was: '{4}' "
          , js_a
          , js_b
          , t.expected.join()
          , js_slice
        )
      )
    }
  }
}
All_Tests.Push(Slice_Node_Tests)
