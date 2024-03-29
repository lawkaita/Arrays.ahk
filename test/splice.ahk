class Splice_Tests {
  Test_Splice() {
    arr := [1,2,3,4]
    res := arr.splice()
    YUnit.assert(res.equals([]))
    res := arr.splice(0)
    YUnit.assert(res.equals([]))
    YUnit.assert(arr.equals([1,2,3,4]))
    res := arr.splice(1)
    YUnit.assert(res.equals([1,2,3,4]))
    YUnit.assert(arr.equals([]))
    arr := res
    res := arr.splice(2)
    YUnit.assert(res.equals([2,3,4]))
    YUnit.assert(arr.equals([1]))
    arr := [1,2,3,4]
    res := arr.splice(3,1,'a','b')
    YUnit.assert(arr.equals([1,2,'a','b',4]))
    YUnit.assert(res.equals([3]))
  }
  Test_Sparse_Array() {
    arr := [1, ,3, ,5]
    res := arr.splice(2,2,'a', ,'b')
    YUnit.assert(res.equals([unset, 3]))
    YUnit.assert(arr.equals([1, 'a', unset, 'b', unset, 5]))
  }
}
All_Tests.push(Splice_Tests)
