class Slice_Tests {
  Test_Empty() {
    YUnit.assert([].slice().equals([]))
    YUnit.assert([].slice(1).equals([]))
    YUnit.assert([].slice(2).equals([]))
    YUnit.assert([].slice(1,2).equals([]))
  }
  Test_Starting_Pos_Zero() {
    YUnit.assert([1,2,3].slice(0).equals([]))
  }
  Test_No_Args() {
    YUnit.assert([1,2,3].slice().equals([1,2,3]))
  }
  Test_Starting_Pos() {
    YUnit.assert([1,2,3].slice(1).equals([1,2,3]))
    YUnit.assert([1,2,3].slice(2).equals([2,3]))
    YUnit.assert([1,2,3].slice(3).equals([3]))
    YUnit.assert([1,2,3].slice(4).equals([]))
    YUnit.assert([1,2,3].slice(-1).equals([3]))
    YUnit.assert([1,2,3].slice(-2).equals([2,3]))
    YUnit.assert([1,2,3].slice(-3).equals([1,2,3]))
    YUnit.assert([1,2,3].slice(-4).equals([1,2,3]))
  }
  Test_Length() {
    YUnit.assert([1,2,3].slice(1,-4).equals([]))
    YUnit.assert([1,2,3].slice(1,-3).equals([]))
    YUnit.assert([1,2,3].slice(1,-2).equals([1]))
    YUnit.assert([1,2,3].slice(1,-1).equals([1,2]))
    YUnit.assert([1,2,3].slice(1,0).equals([]))
    YUnit.assert([1,2,3].slice(1,1).equals([1]), [1,2,3].slice(1,1).toString())
    YUnit.assert([1,2,3].slice(1,2).equals([1,2]))
    YUnit.assert([1,2,3].slice(1,3).equals([1,2,3]))
    YUnit.assert([1,2,3].slice(1,4).equals([1,2,3]))
  }
  Test_Length_And_Starting_Pos() {
    YUnit.assert([1,2,3].slice(2,-4).equals([]))
    YUnit.assert([1,2,3].slice(2,-3).equals([]))
    YUnit.assert([1,2,3].slice(2,-2).equals([]))
    YUnit.assert([1,2,3].slice(2,-1).equals([2]))
    YUnit.assert([1,2,3].slice(2,0).equals([]))
    YUnit.assert([1,2,3].slice(2,1).equals([2]))
    YUnit.assert([1,2,3].slice(2,2).equals([2,3]))
    YUnit.assert([1,2,3].slice(2,3).equals([2,3]))
    YUnit.assert([1,2,3].slice(2,4).equals([2,3]))

    YUnit.assert([1,2,3,4,5].slice(2,-1).equals([2,3,4]))
    YUnit.assert([1,2,3,4,5].slice(2,-2).equals([2,3]))
  }
}
All_Tests.push(Slice_Tests)
