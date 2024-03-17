/* 
  Ahk does not have undefined or null, only two falsy constants,
  the empty string and zero.

  Opinion: the empty string is "more undefined" than zero, since
  StrLen("") == 0 but StrLen(0) == 1, and a function returns the
  the empty string if it finishes executing without explicitly
  returning anything, or if its execution reaches a return 
  statement which has no arguments.

  Therefore, Arrays methods will return the empty string when
  out of any other options.

  ---

  ThisArg: in ahk, the written definition of a method signature
  method(args...) is syntax sugar for a function method(this, args...),
  where this is just a variable name. When an object calls a method
  attached to it, it is placed as the first parameter in the call.

*/
class Arrays {

  static throwExceptions := false
  static stringRepresentationOfUnset := 'unset'

  /*
    This function is only called by Arrays methods.
    It calls the user defined fn, with all the variables that
    fn COULD need. However, the user may have defined fn so
    that it doesnt need them all.

    If fn is a "regular" function, its maxParams property is meaningful
    and using it we can choose what parameters we pass to fn.

    If fn is a BoundFunc, its maxParams is meaningless and we have
    to try to call it all the parameters, dropping one from the end
    until fn accepts the parameter list.
  */
  static _variadic_call(fn, thisArg?, l*) {
    /*
      this function only ever should receive calls from Arrays methods
      so it should never be called with more than 4 arguments in l*.
    */

    if IsSet(thisArg) {
      l.insertAt(1, thisArg)
    }

    if fn.IsVariadic {
    ;if (type(fn) == 'BoundFunc') {
      /*
        UUGLY HACK
      */
      failpointer := {}
      res := failpointer
      /*
        try to call the function fn with argument list l* until it succees
        or we run out of arguments.
      */
      while (res == failpointer) {
        try {
          res := fn(l*)
        } catch Error as e {
          if not Arrays._error_is_from_passing_too_many_parameters_here(e) {
            throw e
          }
          if (l.length == 0) {
            break
          }
          l.pop()
        }
      }
      if (res == failpointer) {
        throw Error('Strange function passed to Arrays method.')
      }
      return res
    }

    l.length := fn.maxParams
    return fn(l*)
  }

  static _error_is_from_passing_too_many_parameters_here(e) {
    /*
      UUGLY HACK
    */
    static expected_message := 'Too many parameters passed to function.'
    static expected_what := ''
    static expected_stack_first_line_substring := ' : [Arrays._variadic_call] '
    if not (type(e) == 'Error') {
      return false
    }
    if not (e.message == expected_message) {
      return false
    }
    if not (type(e.what) == type(expected_what)) {
      return false
    }
    if not (e.what == expected_what) {
      return false
    }
    stack_first_line := strsplit(e.stack, '`n')[1]
    static case_sense := true
    if not InStr(stack_first_line, expected_stack_first_line_substring, case_sense) {
      return false
    }
    return true
  }

  /*
    this function maps 'a' to a positive index of l.

    if 'a' = 0, the function returns 0.

    if 'a' refers outside of the indices of l, then:
      'a' is taken to be endpoint of an infinite
      interval of integers R, either:
        - a is the lower endpoint: R = [a,  infty[, or
        - a is the upper endpoint: R = ]-infty, a].

      the function returns an integer i
      from the set intersection P & R,
      such that i is the closest to 'a', where 
      P be the positive indices of l.

      if the intersection P & R is empty, the function
      returns 0.
  */
  static _normalize_starting_bound(l, a, a_is_lower := true) {
    if (a == 0) {
      return 0
    } else if (1 <= a and a <= l.length) {
      return a
    } else if (-l.length <= a and a <= -1) {
      /*
        - a is in  [-l.length, -1]
        - map a to [1,   l.length]
        this is the same transformation
        that ahk itself does with
        negative indexes.
      */
      return a + l.length + 1
    } else if a_is_lower {  ;  R = [a, infty[
      if (a > l.length)     ;  P & R = {}
        return 0	    ;
      return 1		    ;  (a < -l.length) => P & R = P
    } else {		    ;  R = ]-infty, a]
      if (a > l.length)     ;  P & R = P
        return l.length     
      return 0              ;  (a < -l.length) => P & R = {}
    }
  }

  static _normalize_count(l, a, count) {
    count_all_to_end := l.length - a + 1

    if (count < 0)
      count := count_all_to_end + count

    if (a - 1 + count > l.length)
      count := count_all_to_end

    return count
  }

  static concat(l, ls*) {
    _l := l.clone()
    for _l_ in ls {
      if isSet(_l_) {
	if (_l_ is Array) {
	  for x in _l_ {
	    IsSet(x) ? _l.push(x) : _l.length := _l.length + 1
	  }
	} else {
          _l.push(_l_)
        }
      } else {
        _l.length := _l.length + 1
      }
    }

    return _l
  }

  static flat(l, d := 1) {
    _l := l.clone()
    i := 1
    while (i <= _l.length) {
      if not _l.has(i) {
        _l.removeAt(i)
        continue
      }

      x := _l[i]
      if ((x is Array) and (d > 0)) {
	_l.removeAt(i)  ;  x
	x := Arrays.flat(x, d-1)
	_l.insertAt(i, x*)
	i := i + x.length - 1
      }
      i++
    }
    return _l
  }

  static flatMap(l, fn, thisArg?) {
    _l := []
    for i, x in l {
      if not IsSet(x)
        continue
      y := Arrays._variadic_call(fn, thisArg?, x, i, l)
      if (y is Array)
        _l.push(y*)
      else
        _l.push(y)
    }
    return _l
  }

  static copyWithin(l, target, a, count := l.length) {
    target := Arrays._normalize_starting_bound(l, target, true)
    if not target
      return l

    a := Arrays._normalize_starting_bound(l, a, true)
    if not a
      return l

    if (target == a)
      return l

    count := Arrays._normalize_count(l, a, count)
    if (target < a) {
      i := 0
      step := 1
      range_test := (_i) => (_i < count)
    } else {  ;  target > a
      if (target - 1 + count > l.length)
        count := Arrays._normalize_count(l, target, count)
      i := count - 1
      step := -1
      range_test := (_i) => (_i >= 0)
    }

    while (range_test(i)) {
      if (l.has(a+i)) {
	l[target+i] := l[a+i]
      } else {
	l.delete(target+i)
      }
      i += step
    }

    return l
  }

  static equals(l1, l2) {
    if not (l2 is Array) {
      return false
    }
    if (l1 == l2) {
      return true
    }
    if not (type(l1) == type(l2)) {
      return false
    }
    if not (l1.length == l2.length) {
      return false
    }

    for i, x in l1 {
      if not isSet(x) {
        if l2.has(i) {
          return false
        }
        ;  l1[i] and l2[i] are unset
        continue
      }

      if not l2.has(i) {
        return false
      }

      if not (x == l2[i]) {
        return false
      }
    }
    return true
  }

  static map(l, fn, thisArg?) {
    _l := []
    for i, x in l {
      if IsSet(x) {
        _l.push(Arrays._variadic_call(fn, thisArg?, x, i, l))
      } else {
        _l.length := _l.length + 1
      }
    }
    return _l
  }

  static forEach(l, fn, thisArg?) {
    for i, x in l {
      if IsSet(x) {
        Arrays._variadic_call(fn, thisArg?, x, i, l)
      }
    }
    return ""
  }

  static every(l, fn, thisArg?) {
    for i, x in l {
      if IsSet(x) {
	if not Arrays._variadic_call(fn, thisArg?, x, i, l) {
	  return false
	}
      }
    }
    return true
  }

  static some(l, fn, thisArg?) {
    for i, x in l {
      if IsSet(x) {
	if Arrays._variadic_call(fn, thisArg?, x, i, l) {
	  return true
	}
      }
    }
    return false
  }

  static _mk_array_enumerator(l, ascending, arg_count) {
    if (ascending) {
      if (arg_count > 0) {
        return l.__Enum(arg_count)
      }

      _i := 1
      fn_ascendingIndexEnumerator(&i) {
        if (_i > l.length)
          return false
        i := _i
        _i++
        return true
      }
      return fn_ascendingIndexEnumerator
    }

    _i := l.length

    fn_elementEnumerator(&x) {
      if (_i <= 0)
        return false
      x := l[_i]
      _i--
      return true
    }

    fn_indexEnumerator(&i) {
      if (_i <= 0)
        return false
      i := _i
      _i--
      return true
    }

    fn_indexElementEnumerator(&i, &x) {
      if (_i <= 0)
        return false
      i := _i
      x := l[_i]
      _i--
      return true
    }

    if (arg_count == 1) {
      return fn_elementEnumerator
    } else if (arg_count == 2) {
      return fn_indexElementEnumerator
    } else if (arg_count == 0) {
      return fn_indexEnumerator
    }

    return ""
  }

  static keys(l) {
    return Arrays._mk_array_enumerator(l, true, 0)
  }

  static values(l) {
    return Arrays._mk_array_enumerator(l, true, 1)
  }

  static entries(l) {
    i := 1
    fn_entriesEnumerator(&e) {
      if (i > l.length)
        return false
      e := [i, l.has(i) ? l[i] : unset]
      i++
      return true
    }
    return fn_entriesEnumerator
  }

  static _find(l, fn, ascending, default_?, thisArg?) {
    fn_enum := Arrays._mk_array_enumerator(l, ascending, 2)

    for i, x in fn_enum {
      if Arrays._variadic_call(fn, thisArg?, x?, i, l) {
        return x ?? ""
      }
    }

    if isSet(default_)
      return default_

    if l.hasProp('default')
      return l.default

    if Arrays.hasProp('default')
      return Arrays.default

    if Arrays.throwExceptions
      Throw UnsetItemError("Nothing found.", -1)

    return ""
  }

  static find(l, fn, default_?, thisArg?) {
    return Arrays._find(l, fn, true, default_?, thisArg?)
  }

  static findLast(l, fn, default_?, thisArg?) {
    return Arrays._find(l, fn, false, default_?, thisArg?)
  }

  /*
    returns 0 instead of -1 if nothing is found.
  */
  static findIndex(l, fn, thisArg?) {
    for i, x in l {
      if Arrays._variadic_call(fn, thisArg?, x?, i, l) {
        return i
      }
    }
    return 0
  }

  /*
    returns 0 instead of -1 if nothing is found.
  */
  static findLastIndex(l, fn, thisArg?) {
    fn_enum := Arrays._mk_array_enumerator(l, false, 2)
    for i, x in fn_enum {
      if Arrays._variadic_call(fn, thisArg?, x?, i, l) {
        return i
      }
    }
    return 0
  }

  static includes(l, x?, a:=1) {
    a := Arrays._normalize_starting_bound(l,a,true)
    if (not a)
      return false

    if (IsSet(x)) {
      while (a <= l.length) {
	if (l.has(a))
	  if (x == l[a])
	    return true
	a++
      }
    } else {
      while (a <= l.length) {
	if (not l.has(a))
          return true
	a++
      }
    }
    
    return false
  }

  static filter(l, fn, thisArg?) {
    _l := []
    for i, x in l {
      if IsSet(x) {
	if (Arrays._variadic_call(fn, thisArg?, x, i, l)) {
	  _l.push(x)
	}
      }
    }
    return _l
  }

  static _reduce(l, fn, left, initial?) {
    fn_handleEmpty(l) {
      if l.hasProp('default')
	return l.default

      if Arrays.hasProp('default')
	return Arrays.default

      if Arrays.throwExceptions
	Throw TypeError("Empty array reduced to nothing.", -3)

      return ""
    }

    if (l.length == 0) {
      if isSet(initial)
	return initial

      return fn_handleEmpty(l)
    }

    if (left) {
      if isSet(initial) {
	x := initial
	i := 1
      } else {
        i_x := Arrays.findIndex(l, (x?) => (IsSet(x)))
        if not (i_x)
          return fn_handleEmpty(l)

	x := l[i_x]
	i := i_x + 1
      }

      while (i <= l.length) {
        if (l.has(i)) {
	  x := Arrays._variadic_call(fn, unset, x, l[i], i, l)
        }
	i++
      }
    } else {  ;  reduceRight
      if isSet(initial) {
	x := initial
        i := l.length
      } else {
        i_x := Arrays.findLastIndex(l, (x?) => (IsSet(x)))
        if not (i_x)
          return fn_handleEmpty(l)

	x := l[i_x]
	i := i_x - 1
      }

      while (i > 0) {
        if (l.has(i)) {
	  x := Arrays._variadic_call(fn, unset, x, l[i], i, l)
        }
	i--
      }
    }
    return x
  }

  static reduce(l, fn, initial?) {
    return Arrays._reduce(l, fn, true, initial?)
  }

  static reduceRight(l, fn, initial?) {
    return Arrays._reduce(l, fn, false, initial?)
  }

  static join(l, sep:=',') {
    str := ""
    for i, x in l {
      str .= Arrays._item_to_string(l, x?) . (i < l.length ? sep : '')
    }
    return str
  }

  /*
    this implementation follows the same logic
    as ahk builtin function SubStr
  */
  static slice(l, a:=1, count:=l.length) {
    _l := []

    if (l.length == 0)
      return _l

    a := Arrays._normalize_starting_bound(l,a,true)
    if (not a)
      return _l

    count := Arrays._normalize_count(l, a, count)
    if (count == 0)
      return _l

    b := a - 1 + count
    while (a <= b) {
      if l.has(a)
        _l.push(l[a])
      else 
        _l.length := _l.length + 1

      a++
    }

    return _l
  }

  static splice(l, a := 0, delcount := l.length, items*) {
    _l := []

    if (a == 0)
      return _l
    else if (a > l.length)
      a := l.length + 1
    else if (-l.length <= a and a < 0)
      a := a + l.length + 1
    else if (a < -l.length)
      a := 1
    ;  else a is sane

    if (delcount < 0)
      delcount := 0

    if (a - 1 + delcount > l.length)
      ;  a - 1 + delcount = l.length
      delcount := l.length - a + 1

    _l := Arrays.slice(l,a,delcount)
    if (a <= l.length) {
      l.RemoveAt(a, delcount)
    }
    l.InsertAt(a, items*)
    return _l
  }

  static toSpliced(l, a?, delcount?, items*) {
    _l := l.clone()
    return Arrays.splice(_l, a?, delcount?, items*)
  }

  static ofLength(len) {
    _l := Array()
    _l.length := len
    Arrays.fill(_l, 0)
    return _l
  }

  static fill(l, x, a := 1, count := l.length) {
    a := Arrays._normalize_starting_bound(l,a,true)
    if (not a)
      return l

    count := Arrays._normalize_count(l, a, count)

    i := a
    b := a - 1 + count
    while (i <= b)
      l[i] := x, i++

    return l
  }

  static reverse(l) {
    mid := l.length // 2
    i := 1
    while (i <= mid) {
      j := l.length + 1 - i
      if l.has(i) {
	tmp := l[i]
        if l.has(j)
	  l[i] := l[j]
        else
          l.delete(i)
        l[j] := tmp
      } else {
        if l.has(j) {
	  l[i] := l[j]
          l.delete(j)
        }
        ; else do nothing: l[i] and l[j] are unset
      }
      i++
    }
    return l
  }

  static toReversed(l) {
    _l := l.clone()
    return Arrays.reverse(_l)
  }

  static _item_to_string(l, x?) {
    if not isSet(x)
      return Arrays.stringRepresentationOfUnset
    if (x == l)
      return ''
    if x is Number
      return x
    if x is String
      return x
    if x.hasMethod('toString')
      return String(x)
    return type(x)
  }

  static toString(l) {
    _l := []
    for x in l {
      _l.push(Arrays._item_to_string(l, x?))
    }
    return Arrays.join(_l)
  }

  static shift(l) {
    if (l.has(1) or Arrays.throwExceptions)
      return l.RemoveAt(1)
    if l.hasProp('default')
      return l.default
    if Arrays.hasProp('default')
      return Arrays.default
    return ""
  }

  static unshift(l, args*) {
    l.InsertAt(1, args*)
    return l.length
  }

  static _indexOf(l, x?, a:=1, ascending:=true) {
    if (ascending) {
      step := 1
      range_test := (i) => (i <= l.length)
    } else {
      step := -1
      range_test := (i) => (i > 0)
    }

    a := Arrays._normalize_starting_bound(l, a, ascending)
    if (not a)
      return 0

    if IsSet(x) {
      while (range_test(a)) {
	if l.has(a)
	  if (x == l[a])
	    return a
	a := a + step
      }
      return 0
    }

    while (range_test(a)) {
      if not l.has(a)
	return a
      a := a + step
    }

    return 0
  }

  /*
    returns 0 instead of -1 if nothing is found.
  */
  static indexOf(l,x?,a:=1) {
    return Arrays._indexOf(l, x?, a, true)
  }

  /*
    returns 0 instead of -1 if nothing is found.
  */
  static lastIndexOf(l,x?,a:=l.length) {
    return Arrays._indexOf(l, x?, a, false)
  }

  static prettyPrint(l) {
    return Format("'[{}]'", Arrays.toString(l))
  }

  static sort(l, compareFn?, algorithm?) {
    if not isSet(algorithm) {
      fn_topDownMergeSort(l, compareFn) {
        fn_compareFn(l, i, j) {
          ; unset items are considered greater than any set items.
          if l.has(i) {
            if l.has(j)
              return compareFn(l[i],l[j])
            return -1
          }

          if l.has(j)
            return 1
          return 0
        }
	fn_topDownSplitMerge(l1, a, b, l2) {
	  if (b <= a)
	    return

	  mid := (a + b) // 2
	  fn_topDownSplitMerge(l2, a, mid, l1)
	  fn_topDownSplitMerge(l2, mid+1, b, l1)

	  fn_topDownMerge(l2, a, mid, b, l1)
	}
	fn_topDownMerge(l1, a, mid, b, l2) {
	  i := a        ;  index from a       to mid
	  j := mid + 1  ;  index from mid + 1 to b

	  k := a
	  while (k <= b) {
	    if (i <= mid) and ((j > b) or (fn_compareFn(l1, i, j) <= 0)) {
              ; i is not exhausted and: either j is exhausted, or l1[i] is smaller (or equal) compared to l1[j].
              if (l1.has(i))
	        l2[k] := l1[i]
              else
                l2.delete(k)
	      i++
	    } else {
              ; i is exhausted, or l1[j] < l1[i]
              if (l1.has(j))
	        l2[k] := l1[j]
              else
                l2.delete(k)
	      j++
	    }
	    k++
	  }
	}
	_l := l.clone()
	fn_topDownSplitMerge(l, 1, l.length, _l)
      }
      algorithm := fn_topDownMergeSort
    }
    if not IsSet(compareFn) {
      compareFn := StrCompare
      ;compareFn := (x, y) => (x < y ? -1 : x == y ? 0 : 1)
    }
    algorithm(l, compareFn)
    return l
  }

  static toSorted(l, compareFn?, algorithm?) {
    _l := l.clone()
    return Arrays.sort(_l, compareFn?, algorithm?)
  }

  static fromEnumerator(e, ref_indices := [1]) {
    _null := {}

    /*
      The variables have to exist in
      the scope so that the name substitution
      enum_arg_%i% does not throw an error.
    */

       enum_arg_1
    := enum_arg_2
    := enum_arg_3
    := enum_arg_4
    := enum_arg_5
    := enum_arg_6
    := enum_arg_7
    := enum_arg_8
    := enum_arg_9
    := enum_arg_10
    := enum_arg_11
    := enum_arg_12
    := enum_arg_13
    := enum_arg_14
    := enum_arg_15
    := enum_arg_16
    := enum_arg_17
    := enum_arg_18
    := enum_arg_19
    := _null

    refs := []

    _english_vowels := ['A', 'E', 'I', 'O', 'U', 'Y']  ;  Y is sometimes not a vowel but oh well...
    _n := (s) => (_s := SubStr(s,1,1), Arrays.some(_english_vowels, (x) => (_s = x)))

    if ref_indices is Integer {
      max_i := ref_indices
      ref_indices := []
      i := 1
      while (i <= max_i) {
        ref_indices.push(i)
        i++
      }
    } else if ref_indices is Array {
      max_i := max(ref_indices*)
    } else {
      if Arrays.throwExceptions
	Throw TypeError(Format("Expected an Integer or an Array but got a{} {}."
	    , ( _n(type(ref_indices)) ? "n" : "" )
	    , type(ref_indices)
	  )
	  , -1
	  , ref_indices
	)
      return ""
    }
    i := 1
    while (i <= max_i) {
      refs.push(&enum_arg_%i%)
      i++
    }

    if not e is Enumerator {
      if e.hasMethod('__enum') {
        e := e.__enum(max_i)
      } else if e.hasMethod('call') {
        e_name := e.hasProp('name') ? e.name : ''
        if (SubStr(e_name, -StrLen('.__enum')) = '.__enum') {
          ; user passed the obj.__enum method itself
          ; this detatches the __enum method from obj
          ; there is no way to recover obj from here
          if Arrays.throwExceptions
            Throw TypeError("Got a detached __Enum method.", -1, e_name)
          return ""
        }
        ; assume user passed a custom enum function
        ; e := e
      } else {
        ; e is strange, refuse to do anything
        if Arrays.throwExceptions
	  Throw TypeError(Format("Expected anything enumerable or callable but got a{} {}."
	      , ( _n(type(e)) ? "n" : "" )
	      , type(e)
	    )
	    , -1, e)
        return ""
      }
    }

    _l := []
    while (e(refs*)) {
      _l_ := []

      for i in ref_indices
        _l_.push(enum_arg_%i%)
      _l.insertAt(_l.length + 1, _l_*)
    }
    return _l
  }

  static addMethodsToArrayPrototype() {
    explicit_omit := ['prototype', 'fromEnumerator', 'ofLength', 'addMethodsToArrayPrototype']
    for prop in Arrays.OwnProps() {

      if (InStr(prop, '_', unset, -StrLen(prop)) == 1) {
        continue
      }

      is_explicit_omit := false
      for omit in explicit_omit {
        if (prop = omit) {
          is_explicit_omit := true
          break
        }
      }
      if (is_explicit_omit) {
        continue
      }

      if (hasProp(Array.prototype, prop)) {
        continue
      }

      /*
      desc := Arrays.GetOwnPropDesc(prop)
      f := desc.call
      f_pass_this := (f, this, args*) => (f(Arrays, this, args*))
      desc.call := f_pass_this.bind(f)
      */
      desc := Arrays.GetOwnPropDesc(prop)

      if not desc.hasProp('call') {
        continue
      }

      f  := desc.call      ;   f ~ f(this, l, ...)
      fb := f.bind(Arrays) ;  fb ~ f(Arrays, l, ...)
      desc.call := fb
      
      Array.prototype.defineProp(prop, desc)
    }
  }
}
