class CopyWithin_Tests {
  Test_Copy_Backwards() {
    a := [1,2,3,4,5]
    a.copyWithin(1,4,2)
    YUnit.assert(a.equals([4,5,3,4,5]))

    a := [1,2,3,4,5]
    a.copyWithin(1,4)
    YUnit.assert(a.equals([4,5,3,4,5]))
  }
  Test_Copy_Backwards_Count_Zero() {
    a := [1,2,3,4,5]
    a.copyWithin(1,4,0)
    YUnit.assert(a.equals([1,2,3,4,5]))
  }
  Test_Copy_Forwards_Count_Zero() {
    a := [1,2,3,4,5]
    a.copyWithin(4,1,0)
    YUnit.assert(a.equals([1,2,3,4,5]))
  }
  Test_Copy_Forwards() {
    a := [1,2,3,4,5]
    a.copyWithin(4,1,2)
    YUnit.assert(a.equals([1,2,3,1,2]))
  }
  Test_Copy_Forwards_Copy_Range_Overlaps_With_Target_Range() {
    a := [1,2,3,4,5]
    a.copyWithin(3,2,2)
    YUnit.assert(a.equals([1,2,2,3,5]))

    a := [1,2,3,4,5]
    a.copyWithin(3,2,3)
    YUnit.assert(a.equals([1,2,2,3,4]))

    a := [1,2,3,4,5]
    a.copyWithin(3,2)
    YUnit.assert(a.equals([1,2,2,3,4]))
  }
  Test_Copy_BackWards_Copy_Range_Overlaps_With_Target_Range() {
    a := [1,2,3,4,5]
    a.copyWithin(2,3,3)
    YUnit.assert(a.equals([1,3,4,5,5]))
  }
  Test_Negative_Indices() {
    a := [1,2,3,4,5]
    a.copyWithin(-2,-3)
    YUnit.assert(a.equals([1,2,3,3,4]))
  }
  Test_Copy_Backwards_Negative_Count() {
    a := [1,2,3,4,5]
    a.copyWithin(1,2,-1)
    YUnit.assert(a.equals([2,3,4,4,5]))

    a := [1,2,3,4,5]
    a.copyWithin(1,2,-2)
    YUnit.assert(a.equals([2,3,3,4,5]))

    a := [1,2,3,4,5]
    a.copyWithin(1,2,-3)
    YUnit.assert(a.equals([2,2,3,4,5]))

    a := [1,2,3,4,5]
    a.copyWithin(1,2,-4)
    YUnit.assert(a.equals([1,2,3,4,5]))

    a := [1,2,3,4,5]
    a.copyWithin(1,2,-5)
    YUnit.assert(a.equals([1,2,3,4,5]))
  }
  Test_Copy_Forwards_Negative_Count() {
    a := [1,2,3,4,5]
    a.copyWithin(3,2,-1)
    conio.println(a)
    YUnit.assert(a.equals([1,2,2,3,4]))

    a := [1,2,3,4,5]
    a.copyWithin(3,2,-2)
    YUnit.assert(a.equals([1,2,2,3,5]))

    a := [1,2,3,4,5]
    a.copyWithin(3,2,-3)
    YUnit.assert(a.equals([1,2,2,4,5]))

    a := [1,2,3,4,5]
    a.copyWithin(3,2,-4)
    YUnit.assert(a.equals([1,2,3,4,5]))

    a := [1,2,3,4,5]
    a.copyWithin(3,2,-5)
    YUnit.assert(a.equals([1,2,3,4,5]))
  }
}
All_Tests.push(CopyWithin_Tests)
