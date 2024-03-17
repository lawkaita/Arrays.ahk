class Entries_Tests {
  Test_Get_Unset_Indices() {
    arr := [1, ,3, ,5]
    entries := Arrays.fromEnumerator(arr.entries())
    unset_indices := entries
      .filter(e => (not e.has(2)))
      .map(e => (e[1]))
    YUnit.assert(unset_indices.equals([2,4]))
  }
}
All_Tests.push(Entries_Tests)
