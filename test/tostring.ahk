class ToString_Tests {
  Test_Empty_Array() {
    YUnit.assert([].toString() == '')
  }
  Test_Onetuple() {
    YUnit.assert([1].toString() == '1')
    YUnit.assert(['a'].toString() == 'a')
  }
  Test_Numbers() {
    YUnit.assert([1,2,3].toString() == '1,2,3')
  }
  Test_Strings() {
    YUnit.assert(['abc','d','efg'].toString() == 'abc,d,efg')
  }
  Test_Self() {
    arr := []
    arr.push(arr)
    ; arr is now [arr]
    YUnit.assert(arr.toString() == '')
    arr.push(1)
    ; arr is now [arr, 1]
    YUnit.assert(arr.toString() == ',1')
  }
  Test_Unset() {
    arr := [1, ,3]
    YUnit.assert(arr.toString() == Format('1,{},3', Arrays.stringRepresentationOfUnset))
  }
}
All_Tests.push(ToString_Tests)
