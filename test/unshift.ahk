class UnShift_Tests {
  Test_Unset_Args() {
    arr := [4,5,6]
    arr.unshift(1, ,3)
    YUnit.assert(arr.equals([1, ,3,4,5,6]))
  }
}
All_Tests.push(UnShift_Tests)
