class Includes_Tests {
  Test_Includes() {
    arr := ['a', 'b', 'c']
    YUnit.assert(arr.includes('b'))
    YUnit.assert(arr.includes('b', 2))
    YUnit.assert(arr.includes('b', -2))
  }
  Test_Not_Includes() {
    arr := ['a', 'b', 'c']
    YUnit.assert(not arr.includes('b', 3))
    YUnit.assert(not arr.includes('b', -1))
  }
  Test_Sparse_Array() {
    arr := ['a', , 'b', , 'c']
    YUnit.assert(arr.includes('b'))
    YUnit.assert(arr.includes('b', 2))
    YUnit.assert(not arr.includes('b', -2))
  }
  Test_Includes_Unset() {
    arr := ['a', 'b', 'c']
    YUnit.assert(not arr.includes(unset))
    arr := ['a', , 'b', , 'c']
    YUnit.assert(arr.includes(unset))
    YUnit.assert(not arr.includes(unset, -1))
  }
}
All_Tests.push(Includes_Tests)
