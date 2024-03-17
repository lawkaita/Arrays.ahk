class Reverse_Tests {
  Test_Even_Length() {
    arr := [1,2,3,4]
    YUnit.assert(arr.reverse().equals([4,3,2,1]))
  }
  Test_Odd_Length() {
    arr := [1,2,3,4,5]
    YUnit.assert(arr.reverse().equals([5,4,3,2,1]))
  }
  Test_Sparse_Even_Length() {
    arr := [1, ,3,4,5, , ,8]
    YUnit.assert(arr.reverse().equals([8, , ,5,4,3, ,1]))
  }
  Test_Sparse_Odd_Length() {
    arr := [1, ,3,4,5, , , ,9]
    YUnit.assert(arr.reverse().equals([9, , , ,5,4,3, ,1]))
  }
}
All_Tests.push(Reverse_Tests)
