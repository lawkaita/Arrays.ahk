class Slice_Tests {
  Test_Slice_Same_Start_End() {
    for i in [1,2,3,4] {
      YUnit.assert([1,2,3,4].slice(i,i).equals([i]))
    }
  }
  Test_Zero_Means_Last() {
    arr := [1,2,3,4]
    expected := [4]
    res := arr.slice(0,0)
    YUnit.assert(res.equals(expected))
    res := arr.slice(0)
    YUnit.assert(res.equals(expected))
  }
  Test_Increasing_Start() {
    arr := [1,2,3,4]
    YUnit.assert(arr.slice(-5).equals([1,2,3,4]))
    YUnit.assert(arr.slice(-4).equals([1,2,3,4]))
    YUnit.assert(arr.slice(-3).equals([1,2,3,4]))
    YUnit.assert(arr.slice(-2).equals([2,3,4]))
    YUnit.assert(arr.slice(-1).equals([3,4]))
    YUnit.assert(arr.slice(0).equals([4]))
    YUnit.assert(arr.slice(1).equals([1,2,3,4]))
    YUnit.assert(arr.slice(2).equals([2,3,4]))
    YUnit.assert(arr.slice(3).equals([3,4]))
    YUnit.assert(arr.slice(4).equals([4]))
    YUnit.assert(arr.slice(5).equals([]))

    YUnit.assert(arr.slice(-5,3).equals([1,2,3]))
    YUnit.assert(arr.slice(-4,3).equals([1,2,3]))
    YUnit.assert(arr.slice(-3,3).equals([1,2,3]))
    YUnit.assert(arr.slice(-2,3).equals([2,3]))
    YUnit.assert(arr.slice(-1,3).equals([3]))
    YUnit.assert(arr.slice(0,3).equals([]))
    YUnit.assert(arr.slice(1,3).equals([1,2,3]))
    YUnit.assert(arr.slice(2,3).equals([2,3]))
    YUnit.assert(arr.slice(3,3).equals([3]))
    YUnit.assert(arr.slice(4,3).equals([]))
    YUnit.assert(arr.slice(5,3).equals([]))

    YUnit.assert(arr.slice(-5,2).equals([1,2]))
    YUnit.assert(arr.slice(-4,2).equals([1,2]))
    YUnit.assert(arr.slice(-3,2).equals([1,2]))
    YUnit.assert(arr.slice(-2,2).equals([2]))
    YUnit.assert(arr.slice(-1,2).equals([]))
    YUnit.assert(arr.slice(0,2).equals([]))
    YUnit.assert(arr.slice(1,2).equals([1,2]))
    YUnit.assert(arr.slice(2,2).equals([2]))
    YUnit.assert(arr.slice(3,2).equals([]))
    YUnit.assert(arr.slice(4,2).equals([]))
    YUnit.assert(arr.slice(5,2).equals([]))
  }
  Test_Decreasing_End() {
    arr := [1,2,3,4]
    YUnit.assert(arr.slice(,5).equals([1,2,3,4]))
    YUnit.assert(arr.slice(,4).equals([1,2,3,4]))
    YUnit.assert(arr.slice(,3).equals([1,2,3]))
    YUnit.assert(arr.slice(,2).equals([1,2]))
    YUnit.assert(arr.slice(,1).equals([1]))
    YUnit.assert(arr.slice(,0).equals([1,2,3,4]))
    YUnit.assert(arr.slice(,-1).equals([1,2,3]))
    YUnit.assert(arr.slice(,-2).equals([1,2]))
    YUnit.assert(arr.slice(,-3).equals([1]))
    YUnit.assert(arr.slice(,-4).equals([]))
    YUnit.assert(arr.slice(,-5).equals([]))

    YUnit.assert(arr.slice(2,5).equals([2,3,4]))
    YUnit.assert(arr.slice(2,4).equals([2,3,4]))
    YUnit.assert(arr.slice(2,3).equals([2,3]))
    YUnit.assert(arr.slice(2,2).equals([2]))
    YUnit.assert(arr.slice(2,1).equals([]))
    YUnit.assert(arr.slice(2,0).equals([2,3,4]))
    YUnit.assert(arr.slice(2,-1).equals([2,3]))
    YUnit.assert(arr.slice(2,-2).equals([2]))
    YUnit.assert(arr.slice(2,-3).equals([]))
    YUnit.assert(arr.slice(2,-4).equals([]))
    YUnit.assert(arr.slice(2,-5).equals([]))

    YUnit.assert(arr.slice(3,5).equals([3,4]))
    YUnit.assert(arr.slice(3,4).equals([3,4]))
    YUnit.assert(arr.slice(3,3).equals([3]))
    YUnit.assert(arr.slice(3,2).equals([]))
    YUnit.assert(arr.slice(3,1).equals([]))
    YUnit.assert(arr.slice(3,0).equals([3,4]))
    YUnit.assert(arr.slice(3,-1).equals([3]))
    YUnit.assert(arr.slice(3,-2).equals([]))
    YUnit.assert(arr.slice(3,-3).equals([]))
    YUnit.assert(arr.slice(3,-4).equals([]))
    YUnit.assert(arr.slice(3,-5).equals([]))
  }

}
