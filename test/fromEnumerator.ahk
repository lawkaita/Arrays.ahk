class FromEnumerator_Tests {
  Test_Integer() {
    _fromEnumerator := Arrays.fromEnumerator.bind(Arrays)
    YUnit.assert(ThrowsError([TypeError
        , "Expected anything enumerable or callable but got an Integer.", 'Arrays.fromEnumerator', '23']
      , _fromEnumerator, 23))
  }
  Test_String_As_Ref_Indices() {
    _fromEnumerator := Arrays.fromEnumerator.bind(Arrays)
    YUnit.assert(ThrowsError([TypeError
	, "Expected an Integer or an Array but got a String."
	, 'Arrays.fromEnumerator', 'foo']
      , _fromEnumerator, [1,2,3], "foo"))
  }
  Test_Array() {
    arr := [1,2,3]
    YUnit.assert(Arrays.fromEnumerator(arr).equals(arr))
    YUnit.assert(Arrays.fromEnumerator(arr, 1).equals(arr))
  }
  Test_Array__Enum() {
    arr := [1,2,3]
    _fromEnumerator := Arrays.fromEnumerator.bind(Arrays)
    YUnit.assert(ThrowsError([TypeError
        , "Got a detached __Enum method.", 'Arrays.fromEnumerator', 'Array.Prototype.__Enum']
      , _fromEnumerator, arr.__enum))
  }
  Test_Array__Enumerator() {
    arr := [1,2,3]
    YUnit.assert(Arrays.fromEnumerator(arr.__enum(1)).equals(arr))
  }
  Test_Map() {
    m := Map('a', 'abc', 'b', 'bbc', 'c', 'ccc')
    YUnit.assert(Arrays.fromEnumerator(m).equals(['a','b','c']))
    YUnit.assert(Arrays.fromEnumerator(m,[1]).equals(['a','b','c']))
    YUnit.assert(Arrays.fromEnumerator(m,[1,2]).equals([
      'a', 'abc',
      'b', 'bbc',
      'c', 'ccc'
    ]))
    YUnit.assert(Arrays.fromEnumerator(m,2).equals([
      'a', 'abc',
      'b', 'bbc',
      'c', 'ccc'
    ]))
    YUnit.assert(Arrays.fromEnumerator(m,[2]).equals([
      'abc',
      'bbc',
      'ccc'
    ]))
    YUnit.assert(Arrays.fromEnumerator(m.__enum(2),[2]).equals([
      'abc',
      'bbc',
      'ccc'
    ]))
  }
  Test_Object() {
    obj := {a: 'abc', b: 'bbc', c: 'ccc'}
    YUnit.assert(Arrays.fromEnumerator(obj.OwnProps(),[1,2]).equals([
      'a', 'abc',
      'b', 'bbc',
      'c', 'ccc'
    ]))
  }
  Test_More_Than_Two_Indices() {
    leporidae := [
      {
	name: 'Jazz',
	species: 'jackrabbit',
	gun: 'LFG9000',
	color: 'green'
      },
      {
        name: 'Judy Hopps',
        color: 'gray',
        species: 'rabbit',
        gun: 'Tranquilizer gun'
      },
      {
        species: 'rabbit',
        color: 'orange',
        name: 'Lola Bunny'
      }
    ]

    mk_get_name_species_color(list) {
      i := 1
      get_name_species_color(&name,&species,&color) {
	if (i > list.length)
	  return false
	name := list[i].name
	species := list[i].species
	color := list[i].color
	i++
	return true
      }
      return get_name_species_color
    }

    fn := mk_get_name_species_color(leporidae)
    YUnit.assert(Arrays.fromEnumerator(fn,[1,2,3]).equals([
      'Jazz',       'jackrabbit', 'green',
      'Judy Hopps', 'rabbit',     'gray',
      'Lola Bunny', 'rabbit',     'orange'
    ]))
    fn := mk_get_name_species_color(leporidae)
    YUnit.assert(Arrays.fromEnumerator(fn,3).equals([
      'Jazz',       'jackrabbit', 'green',
      'Judy Hopps', 'rabbit',     'gray',
      'Lola Bunny', 'rabbit',     'orange'
    ]))
    fn := mk_get_name_species_color(leporidae)
    YUnit.assert(Arrays.fromEnumerator(fn,[1,3]).equals([
      'Jazz',       'green',
      'Judy Hopps', 'gray',
      'Lola Bunny', 'orange'
    ]))
  }
}
All_Tests.push(FromEnumerator_Tests)
