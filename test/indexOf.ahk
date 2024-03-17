class IndexOf_Tests {
  Test_Item_Exists() {
    YUnit.assert(['a','b','c','b'].indexOf('b') == 2)
  }
  Test_Item_Not_Exists() {
    YUnit.assert(['a','b','c','b'].indexOf('d') == 0)
  }
  Test_Find_First() {
    YUnit.assert(['a','b','c','b'].indexOf('a') == 1)
  }
  Test_Find_Last() {
    YUnit.assert(['a','b','b','c'].indexOf('c') == 4)
  }
  Test_Fromindex_Positive() {
    YUnit.assert(['a','b','c','b','d'].indexOf('b', 2) == 2)
    YUnit.assert(['a','b','c','b','d'].indexOf('b', 3) == 4)
  }
  Test_Fromindex_Negative() {
    YUnit.assert(['a','b','c','b','d'].indexOf('b', -3) == 4)
  }
  Test_Sparse_Arrays() {
    YUnit.assert(['a',   ,'c',   ,'d'].indexOf('c') == 3)
    YUnit.assert(['a',   ,'c',   ,'d'].indexOf('a') == 1)
    YUnit.assert(['a',   ,'c',   ,'d'].indexOf('d') == 5)
  }
  Test_IndexOf_Unset() {
    YUnit.assert(['a',   ,'c',   ,'d'].indexOf(unset) == 2)
    YUnit.assert(['a',   ,'c',   ,'d'].indexOf(unset, 5) == 0)
  }
}
All_Tests.push(IndexOf_Tests)
