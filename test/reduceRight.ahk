class ReduceRight_Tests {
  Test_Concat() {
    arr := [1,2,3,4,5]
    res := arr.reduceRight((x,y) => (x . y))
    YUnit.assert(res == "54321")
  }
}
All_Tests.push(ReduceRight_Tests)
