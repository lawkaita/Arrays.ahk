class ReduceRight_Tests {
  Test_Concat() {
    arr := [1,2,3,4,5]
    res := arr.reduceRight((x,y) => (x . y))
    YUnit.assert(res == "54321")
  }
  Test_Sparse_Array() {
    arr := [1, ,3, ,5]
    res := arr.reduceRight((x,y) => (x . y))
    YUnit.assert(res == "531")
  }
}
All_Tests.push(ReduceRight_Tests)
