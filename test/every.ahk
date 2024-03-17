class Every_Tests {
  Test_Every_With_One_Falsy() {
    YUnit.assert(not [1,2,3,4,0,5].every((x) => (x)))
  }
  Test_Every_With_All_Truth() {
    YUnit.assert([1,2,3,4,9,5].every((x) => (x)))
  }
}
