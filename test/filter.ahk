class Filter_Tests {
  Test_Filter_Numbers() {
    YUnit.assert(['a', 1, 'b', 2, 3, 'c'].filter(x => x is number).equals([1,2,3]))
  }
  Test_Filter_Strings() {
    YUnit.assert(['a', 1, 'b', 2, 3, 'c'].filter(x => x is string).equals(['a','b','c']))
  }
  Test_Filter_Classes() {
    stuff := [
      Error
      , MsgBox
      , Number
      , 1
      , 'a' 
      , DllCall
    ]
    expected := [
      Error
      , Number
    ]
    res := stuff.filter(x => (type(x) == 'Class'))
    YUnit.assert(res.equals(expected))
  }
  Test_Accessing_Indices() {
    index_is_even(x,i) {
      return (Mod(i, 2) == 0)
    }
    YUnit.assert(strsplit('abcdefg').filter(index_is_even).equals(strsplit('bdf')))
  }
  Test_Accessing_Calling_Array() {
    is_local_maximum(x,i,l) {
      prev := i > 1        ? l[i-1] : x
      next := i < l.length ? l[i+1] : x
      return (prev <= x and next <= x)
    }
    f := [1,3,6,-1,3,3,3,4,5,7]
    YUnit.assert(f.filter(is_local_maximum).equals([6,3,3,7]))
  }
}
All_Tests.push(Filter_Tests)
