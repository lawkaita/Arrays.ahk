class FindIndex_Tests {
  Test_Equals_Number() {
    arr := [1,2,3,4,5]
    result := arr.findIndex( (x) => (x == 4) )
    YUnit.assert(result == 4)
  }
  Test_Alphabetic() {
    stuff := [1, ':', 3, [], 'abc', (() => (0)), '']
    result := stuff.findIndex(
        (x) => ((x is String) and (x ~= 'i)[a-z]+')))
    YUnit.assert(result == 5)
  }
  Test_Element_Not_In_Array() {
    arr := [1,2,3,4,5]
    result := arr.findIndex( (x) => (x == 6) )
    YUnit.assert(result == 0)
  }
  Test_Unset() {
    arr := [1,2,unset,4,unset,6]
    result := arr.findIndex( (x?) => (not IsSet(x)) )
    YUnit.assert(result == 3)
  }
  Test_Not_Unset() {
    arr := [unset,unset,unset,1,2,unset,4,unset,6]
    result := arr.findIndex( (x?) => (IsSet(x)) )
    YUnit.assert(result == 4)
  }

}
All_Tests.push(FindIndex_Tests)
