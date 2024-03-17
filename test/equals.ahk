class Equals_Tests {
  Test_Numbers() {
    a := [1,2,3]
    b := [1,2,3]
    YUnit.assert(a.equals(b))
  }
  Test_Numbers_Different() {
    a := [1,2,3]
    b := [1,2,4]
    YUnit.assert(not a.equals(b))
  }
  Test_Strings() {
    a := ['a','b','c']
    b := ['a','b','c']
    YUnit.assert(a.equals(b))
  }
  Test_Same() {
    a := []
    YUnit.assert(a.equals(a))
  }
  Test_Against_Object() {
    YUnit.assert(not [].equals({}))
  }
  Test_Containing_Object() {
    o := {}
    a := [o]
    b := [o]
    YUnit.assert(a.equals(b))
  }
  Test_Containing_Classes() {
    YUnit.assert([Error, Number].equals([Error, Number]))
  }
  Test_Containing_Different_Object() {
    o := {}
    u := {}
    a := [o]
    b := [u]
    YUnit.assert(not a.equals(b))
  }
  Test_Different_Length() {
    YUnit.assert(not [1,2,3].equals([1,2,3,4]))
  }
}
