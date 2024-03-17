class LastIndexOf_Tests {
  Test_Item_Exists() {
    YUnit.assert(['a','b','c','b'].lastIndexOf('b') == 4)
  }
  Test_Item_Not_Exists() {
    YUnit.assert(['a','b','c','b'].lastIndexOf('d') == 0)
  }
  Test_Find_First() {
    YUnit.assert(['a','b','c','b'].lastIndexOf('a') == 1)
  }
  Test_Find_Last() {
    YUnit.assert(['a','b','b','c'].lastIndexOf('c') == 4)
  }
  Test_Fromindex_Positive() {
    YUnit.assert(['a','b','c','b','d'].lastIndexOf('b', 2) == 2)
    YUnit.assert(['a','b','c','b','d'].lastIndexOf('b', 1) == 0)
  }
  Test_Fromindex_Negative() {
    YUnit.assert(['a','b','c','b','d'].lastIndexOf('b', -1) == 4)
    YUnit.assert(['a','b','c','b','d'].lastIndexOf('b', 5) == 4)
  }
  Test_LastIndexOf_Unset() {
    YUnit.assert(['a',   ,'c',   ,'d'].lastIndexOf(unset) == 4)
    YUnit.assert(['a',   ,'c',   ,'d'].lastIndexOf(unset, 5) == 4)
    YUnit.assert(['a',   ,'c',   ,'d'].lastIndexOf(unset, 1) == 0)
  }
}
All_Tests.push(LastIndexOf_Tests)
