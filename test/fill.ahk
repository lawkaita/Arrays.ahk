class Fill_Tests {
  Test_Fill_All() {
    YUnit.assert([1,2,3,4].fill(0).equals([0,0,0,0]))
  }
  Test_Fill_Starting() {
    YUnit.assert([1,2,3,4].fill(0,3).equals([1,2,0,0]))
  }
  Test_Fill_Count() {
    YUnit.assert([1,2,3,4].fill(0,2,2).equals([1,0,0,4]))
  }
}
All_Tests.push(Fill_Tests)
