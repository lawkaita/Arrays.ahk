;#include <v2/peep/script/peep.v2>
;peep.display_text := false
;peep.include_properties := false
class Flat_Tests {
  Begin() {
    ; search ahk help for Variable Capacity And Memory
    this.MaxInt := 0x7FFFFFFFFFFFFFFF
  }
  Test_Already_Flat() {
    a := [1,2,3]
    b := a.flat()
    YUnit.assert(not a == b)
    YUnit.assert(a.equals(b))
  }
  Test_Depth_One() {
    a := [1,2,[3,4],5]
    b := a.flat()
    YUnit.assert(b.equals([1,2,3,4,5]))
    b := a.flat(1)
    YUnit.assert(b.equals([1,2,3,4,5]))
    b := a.flat(0)
    c := a[3]
    YUnit.assert(b.equals([1,2,c,5]))
  }
  Test_Depth_Two() {
    c := [4]
    a := [1,2,[3,c],5]
    b := a.flat()
    YUnit.assert(b.equals([1,2,3,c,5]))
    b := a.flat(2)
    YUnit.assert(b.equals([1,2,3,4,5]))
  }
  Test_Empty_Arrays_Disappear() {
    c := []
    a := [1,2,[3,c],5]
    b := a.flat()
    YUnit.assert(b.equals([1,2,3,c,5]))
    b := a.flat(2)
    YUnit.assert(b.equals([1,2,3,5]))
  }
  Test_Very_Deep() {
    a := []
    current := a

    expected := []
    i := 1
    while (i <= 100) {
      expected.push(i)

      _a := [i]
      current.push(_a)
      current := _a

      i++
    }

    YUnit.assert(expected[1] == 1)
    YUnit.assert(expected[2] == 2)
    YUnit.assert(expected[3] == 3)
    YUnit.assert(expected[4] == 4)
    ; ...

    YUnit.assert(a[1][1]          == 1)
    YUnit.assert(a[1][2][1]       == 2)
    YUnit.assert(a[1][2][2][1]    == 3)
    YUnit.assert(a[1][2][2][2][1] == 4)
    ; ...

    result := a.flat(1)

    YUnit.assert(result[1]          == 1)
    YUnit.assert(result[2][1]       == 2)
    YUnit.assert(result[2][2][1]    == 3)
    YUnit.assert(result[2][2][2][1] == 4)
    ; ...

    result := a.flat(this.MaxInt)
    YUnit.assert(result.equals(expected))

    result := a.flat(99)

    result_head   := result.pop()    ;  modify result
    expected_head := expected.pop()  ;  modify expected

    Yunit.assert(result.equals(expected))
    YUnit.assert(result_head.equals([100]))
  }
  Test_Sparse_Array() {
    arr := [1,unset,3,unset,5,unset]
    res := arr.flat(0)
    YUnit.assert(res.equals([1,3,5]))
    res := arr.flat()
    YUnit.assert(res.equals([1,3,5]))

    dont_flatten_me := [7,8,unset]
    arr := [1,unset,3,[unset,4],5,[6,dont_flatten_me,unset,10]]
    res := arr.flat()
    YUnit.assert(res.equals([1,3,4,5,6,dont_flatten_me,10]))
    res := arr.flat(2)
    YUnit.assert(res.equals([1,3,4,5,6,7,8,10]))

  }
}
All_Tests.push(Flat_Tests)
