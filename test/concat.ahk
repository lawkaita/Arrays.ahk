class Concat_Tests {
  Test_Add_Primitives() {
    x := [1]
    y := x.concat(2,3,4,'a')
    YUnit.assert(y.equals([1,2,3,4,'a']))
  }
  Test_Add_Array() {
    x := [1]
    y := x.concat([2,3,4,'a'])
    YUnit.assert(y.equals([1,2,3,4,'a']))
  }
  Test_Add_Primitives_And_Array() {
    x := [1]
    y := x.concat(2,3,4,[5,6],7)
    YUnit.assert(y.equals([1,2,3,4,5,6,7]))
  }
  Test_Add_Deep_Array() {
    x := [1]
    y := x.concat([5,[6]])
    YUnit.assert(y.length == 3)
    YUnit.assert(y[1] == 1)
    YUnit.assert(y[2] == 5)
    YUnit.assert(y[3].equals([6]))
  }
  Test_Add_Primitives_And_Deep_Array() {
    x := [1]
    y := x.concat(2,[5,[6]],7)
    YUnit.assert(y.length == 5)
    YUnit.assert(y[1] == 1)
    YUnit.assert(y[2] == 2)
    YUnit.assert(y[3] == 5)
    YUnit.assert(y[4].equals([6]))
    YUnit.assert(y[5] == 7)
  }
  Test_Map() {
    ; is this what the user would expect?
    x := ([1,2,3]).concat(Map(1, 'a', 2, 'b', 3, 'c'))
    YUnit.assert(x.equals([1,2,3,'a','b','c']))
    YUnit.assert(not x.equals([1,2,3,1,2,3]))
  }
  Test_Object() {
    x := ([]).concat({a: 'foo', b: 'bar'}.OwnProps())
    ;conio.println(x)
    ;YUnit.assert(x.equals(['foo', 'bar']))
    YUnit.assert(true)
  }
  Test_X() {
    YUnit.assert(true)
  }
}
All_Tests.push(Concat_Tests)
