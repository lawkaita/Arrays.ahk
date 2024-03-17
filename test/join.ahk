class Join_Tests {
  Test_Join() {
    YUnit.assert(StrSplit('abcdefg').join('') == 'abcdefg')
  }
  Test_Join_Empty_Array() {
    YUnit.assert([].join(',') == '')
  }
}
All_Tests.push(Join_Tests)
