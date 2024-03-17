class FlatMap_Tests {
  Test_Flattens() {
    arr := [1,2,1]
    res := arr.flatMap((x) => (x == 2 ? [2,2] : 1))
    YUnit.assert(res.equals([1,2,2,1]))
  }
  Test_Powers_Of_Two() {
    arr := [0,1,2,3,4]
    res := arr.flatMap((x => [x, x ** 2]))
    YUnit.assert(res.equals([0,0,1,1,2,4,3,9,4,16]))
  }
  Test_Two_To_The_X() {
    arr := [0,1,2,3,4]
    res := arr.flatMap((x => [x, 2 ** x]))
    YUnit.assert(res.equals([0,1,1,2,2,4,3,8,4,16]))
  }

}
All_Tests.push(FlatMap_Tests)
