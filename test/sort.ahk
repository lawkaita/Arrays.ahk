class Sort_Tests {
  Test_Default_Sort() {
    YUnit.assert([4,2,3,1,11].sort().equals([1,11,2,3,4]))
  }
  Test_Default_Sort_With_Zero() {
    YUnit.assert([4,2,3,1,11,0].sort().equals([0,1,11,2,3,4]))
  }
  Test_Numeric_Sort() {
    compareFn := (x, y) => (x < y ? -1 : x == y ? 0 : 1)
    YUnit.assert([4,2,3,1,11].sort(compareFn).equals([1,2,3,4,11]))
  }
  Test_Custom_Algorithm() {
    fn_gnomeSort(l, compareFn) {
      i := 1
      while (i <= l.length) {
        if (i == 1) or (compareFn(l[i], l[i-1]) >= 0) {
          i++
        } else {
          tmp := l[i]
          l[i] := l[i-1]
          l[i-1] := tmp
          i--
        }
      }
    }
    YUnit.assert([4,2,3,1,11].sort(unset, fn_gnomeSort).equals([1,11,2,3,4]))
    fn_compareNumeric := (x, y) => (x < y ? -1 : x == y ? 0 : 1)
    YUnit.assert([4,2,3,1,11].sort(fn_compareNumeric, fn_gnomeSort).equals([1,2,3,4,11]))
  }
  Test_Broken_Custom_Algorithm() {
    fn_dontSort(l, compareFn) {
      return
    }
    YUnit.assert([4,2,3,1,11].sort(unset, fn_dontSort).equals([4,2,3,1,11]))
  }
  Test_Sort_Objects() {
    compareFn := (x, y) => (x.key < y.key ? -1 : x.key == y.key ? 0 : 1)
    objects := [
      {key: 4},
      {key: 2},
      {key: 3},
      {key: 1}
    ]
    objects_sorted := [objects[4],objects[2],objects[3],objects[1]]
    YUnit.assert(objects.sort(compareFn).equals(objects_sorted))
  }
  Test_Sparse_Array() {
    YUnit.assert(['a', unset, 'c', unset, 'b'].sort().equals(['a','b','c', unset, unset]))
  }
}
All_Tests.push(Sort_Tests)
