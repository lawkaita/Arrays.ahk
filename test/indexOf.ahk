class IndexOf_Tests {
  Test_Item_Exists() {
    YUnit.assert(['a','b','c'].indexOf('b') == 2)
  }
  Test_Item_Not_Exists() {
    YUnit.assert(['a','b','c'].indexOf('d') == 0)
  }
  Test_Fromindex_Positive() {
    YUnit.assert(['a','b','c','b','d'].indexOf('b', 2) == 2)
    YUnit.assert(['a','b','c','b','d'].indexOf('b', 3) == 4)
  }
  Test_Fromindex_Negative() {
    YUnit.assert(['a','b','c','b','d'].indexOf('b', -3) == 4)
  }
}
All_Tests.push(IndexOf_Tests)
