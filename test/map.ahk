class Map_Tests {
  Test_Map_Power_Of_Two() {
    powers := [0,1,2,3,4].map((x) => (x**2))
    YUnit.assert(powers.equals([0,1,4,9,16]))
  }
  Test_Map_Two_To_The_X() {
    powers := [0,1,2,3,4].map((x) => (2**x))
    YUnit.assert(powers.equals([1,2,4,8,16]))
  }
  Test_Indices() {
    result := ['a','b','c'].map((x, i) => (i . ": " x)).join(', ')
    YUnit.assert(result == '1: a, 2: b, 3: c')
  }
  Test_Accessing_Calling_Array() {
    this_and_previous_are_ones(x,i,l) {
      if (i == 1) {
        return false
      }
      return ((x == '1') and (l[i-1] == '1'))
    }

    input_str    := '1100101110101'
    expected_str := '0100000110000'

    these_and_their_previous_are_ones := strsplit(input_str)
      .map((x,i,l) => this_and_previous_are_ones(x,i,l))

    YUnit.assert(these_and_their_previous_are_ones
      .equals(strsplit(expected_str)))
  }
}
