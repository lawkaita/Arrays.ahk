class Arrays {

  static throwExceptions := false

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
  static _variadic_call(fn, l*) {
    /*
      this function only ever should receive calls from Arrays methods
      so it should never be called with more than 4 arguments in l*.
    */
    if (type(fn) == 'BoundFunc') {
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
    switch fn.maxparams {
      case 0: return fn()
      case 1: return fn(l[1])
      case 2: return fn(l[1], l[2])
      case 3: return fn(l[1], l[2], l[3])
      case 4: return fn(l[1], l[2], l[3], l[4])
    }
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
  static _positive_index_of(l, a, a_is_lower := true) {
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
    } else {		    ;  a_is_upper => R = ]-infty, a]
      if (a > l.length)     ;  P & R = P
        return l.length     
      return 0              ;  (a < -l.length) => P & R = {}
    }
  }

  static concat(l, ls*) {
    _l := l.clone()
    for _l_ in ls {
      if (_l_ is Array) {
	for x in _l_ {
	  _l.push(x)
        }
      } else {
        _l.push(_l_)
      }
    }

    return _l
  }

  static flat(l, d) {
    _l := l.clone()
    if (d <= 0)
      return _l

    i := 1
    end := _l.length
    while (i <= end) {
      x := _l[i]
      if (x is Array) {
        _l.removeAt(i)  ;  x
        x := Arrays.flat(x, d-1)
        _l.insertAt(i, x*)
      }
      i++
    }
    return _l
  }

  static equals(l1, l2) {
    if (l1 == l2) {
      return true
    }
    if not (l2 is Array) {
      return false
    }
    if not (type(l1) == type(l2)) {
      return false
    }
    if not (l1.length == l2.length) {
      return false
    }

    for i, x in l1 {
      if not (x == l2[i]) {
        return false
      }
    }
    return true
  }

  static map(l, fn) {
    _l := []
    for i, x in l {
      _l.push(Arrays._variadic_call(fn, x, i, l))
    }
    return _l
  }

  static forEach(l, fn) {
    for i, x in l {
      Arrays._variadic_call(fn, x, i, l)
    }
  }

  static every(l, fn) {
    for i, x in l {
      if not Arrays._variadic_call(fn, x, i, l) {
        return false
      }
    }
    return true
  }

  static some(l, fn) {
    for i, x in l {
      if Arrays._variadic_call(fn, x, i, l) {
        return true
      }
    }
    return false
  }

  static find(l, fn, default_?) {
    for i, x in l {
      if Arrays._variadic_call(fn, x, i, l) {
        return x
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

    return 0
  }

  /*
    returns 0 instead of -1 if nothing is found.
  */
  static findIndex(l, fn) {
    for i, x in l {
      if Arrays._variadic_call(fn, x, i, l) {
        return i
      }
    }
    return 0
  }

  static includes(l, x, a:=1) {
    a := Arrays._positive_index_of(l,a,true)
    if (not a)
      return false

    while (a <= l.length) {
      if (x == l[a])
        return true
      a++
    }
    
    return false
  }

  static filter(l, fn) {
    _l := []
    for i, x in l {
      if (Arrays._variadic_call(fn, x, i ,l)) {
        _l.push(x)
      }
    }
    return _l
  }

  static reduce(l, fn, initial?) {
    if (l.length == 0) {
      if isSet(initial)
	return initial

      if l.hasProp('default')
	return l.default

      if Arrays.hasProp('default')
	return Arrays.default

      if Arrays.throwExceptions
	Throw TypeError("Empty array reduced to nothing.", -1)

      return 0  ;; ahk none/false/null
    }

    if isSet(initial) {
      x := initial
      i := 1
    } else {
      x := l[1]
      i := 2
    }

    while (i <= l.length) {
      x := Arrays._variadic_call(fn, x, l[i], i, l)
      i++
    }
    return x
  }

  static join(l, sep:=',') {
    str := ""
    for i, x in l {
      str .= x . (i < l.length ? sep : '')
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

    a := Arrays._positive_index_of(l,a,true)
    if (not a)
      return _l

    if (count == 0)
      return _l
    else if (count > 0)
      b := Min(a - 1 + count, l.length)
    else  ;  count < 0
      b := Max(l.length + count, 0)

    while (a <= b)
      _l.push(l[a]), a++

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
    return Arrays.splice(_l, a ?? unset, delcount ?? unset, items*)
  }

  static ofLength(len) {
    _l := Array()
    _l.length := len
    Arrays.fill(_l, 0)
    return _l
  }

  static fill(l, x, a := 1, count := l.length) {
    a := Arrays._positive_index_of(l,a,true)
    if (not a)
      return l

    ; TODO: standardize count/b getting
    ; TODO: create custom iterators that take a sub range and can reverse?
    if (a - 1 + count > l.length)
      count := l.length - a + 1

    i := 1
    while (i <= count)
      l[a-1+i] := x, i++

    return l
  }

  static reverse(l) {
    mid := l.length // 2
    i := 1
    while (i <= mid) {
      tmp := l[i]
      j := l.length + 1 - i
      l[i] := l[j]
      l[j] := tmp
      i++
    }
    return l
  }

  static toReversed(l) {
    _l := l.clone()
    return Arrays.reverse(_l)
  }

  static toString(l) {
    fn_toString(x,i,l) {
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
    return Arrays.join(Arrays.map(l,fn_toString))
  }

  static shift(l) {
    return l.RemoveAt(1)
  }

  static unshift(l, args*) {
    l.InsertAt(1, args*)
    return l.length
  }

  static _indexOf(l, x, a, ascending) {
    if (ascending) {
      a_is_lower_endpoint := true
      step := 1
      range_test := (i) => (i < l.length)
    } else {
      a_is_lower_endpoint := false
      step := -1
      range_test := (i) => (i > 0)
    }

    a := Arrays._positive_index_of(l, a, a_is_lower_endpoint)
    if (not a)
      return 0

    while (range_test(a)) {
      if (x == l[a])
        return a
      a := a + step
    }

    return 0
  }

  /*
    returns 0 instead of -1 if nothing is found.
  */
  static indexOf(l,x,a:=1) {
    return Arrays._indexOf(l,x,a,true)
  }

  /*
    returns 0 instead of -1 if nothing is found.
  */
  static lastIndexOf(l,x,a:=l.length) {
    return Arrays._indexOf(l,x,a,false)
  }

  static prettyPrint(l) {
    return Format("'[{}]'", Arrays.toString(l))
  }

  static sort(l, compareFn?, algorithm?) {
    if not isSet(algorithm) {
      fn_topDownMergeSort(l, compareFn) {
	fn_topDownSplitMerge(l1, a, b, l2) {
	  if (b <= a)
	    return

	  mid := (a + b) // 2
	  fn_topDownSplitMerge(l2, a, mid, l1)
	  fn_topDownSplitMerge(l2, mid+1, b, l1)

	  fn_topDownMerge(l2, a, mid, b, l1)
	}
	fn_topDownMerge(l1, a, mid, b, l2) {
	  i := a
	  j := mid + 1

	  k := a
	  while (k <= b) {
	    if (i <= mid) and ((j > b) or ( compareFn(l1[i], l1[j]) <= 0 )) {
	      l2[k] := l1[i]
	      i++
	    } else {
	      l2[k] := l1[j]
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
    return Arrays.sort(_l, compareFn ?? unset, algorithm ?? unset)

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
    } else if ref_indices is Array
      max_i := max(ref_indices*)
    else {
      Throw TypeError(Format("Expected an Integer or an Array but got a{} {}."
          , ( _n(type(ref_indices)) ? "n" : "" )
          , type(ref_indices)
        )
        , -1
        , ref_indices
      )
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
          Throw TypeError("Got a detached __Enum method.", -1, e_name)
        }
        ; assume user passed a custom enum function
        ; e := e
      } else {
        ; e is strange, refuse to do anything
        Throw TypeError(Format("Expected anything enumerable or callable but got a{} {}."
            , ( _n(type(e)) ? "n" : "" )
            , type(e)
          )
          , -1, e)
      }
    }

    _l := []
    while (true) {
      _l_ := []
      items_remaining := e(refs*)
      if not items_remaining
        break

      for i in ref_indices
        _l_.push(enum_arg_%i%)
      _l.insertAt(_l.length + 1, _l_*)
    }
    return _l
  }

  static _addMethods() {
    Array.prototype.equals      := (args*) => (Arrays.equals(args*))
    Array.prototype.map         := (args*) => (Arrays.map(args*))
    Array.prototype.filter      := (args*) => (Arrays.filter(args*))
    Array.prototype.reduce      := (args*) => (Arrays.reduce(args*))
    Array.prototype.join        := (args*) => (Arrays.join(args*))
    Array.prototype.forEach     := (args*) => (Arrays.forEach(args*))
    Array.prototype.slice       := (args*) => (Arrays.slice(args*))
    Array.prototype.every       := (args*) => (Arrays.every(args*))
    Array.prototype.some        := (args*) => (Arrays.some(args*))
    Array.prototype.find        := (args*) => (Arrays.find(args*))
    Array.prototype.findIndex   := (args*) => (Arrays.findIndex(args*))
    Array.prototype.includes    := (args*) => (Arrays.includes(args*))
    Array.prototype.toString    := (args*) => (Arrays.toString(args*))
    Array.prototype.splice      := (args*) => (Arrays.splice(args*))
    Array.prototype.toSpliced   := (args*) => (Arrays.toSpliced(args*))
    Array.prototype.reverse     := (args*) => (Arrays.reverse(args*))
    Array.prototype.toReversed  := (args*) => (Arrays.toReversed(args*))
    Array.prototype.prettyPrint := (args*) => (Arrays.prettyPrint(args*))
    Array.prototype.shift       := (args*) => (Arrays.shift(args*))
    Array.prototype.unshift     := (args*) => (Arrays.unshift(args*))
    Array.prototype.concat      := (args*) => (Arrays.concat(args*))
    Array.prototype.indexOf     := (args*) => (Arrays.indexOf(args*))
    Array.prototype.lastIndexOf := (args*) => (Arrays.lastIndexOf(args*))
    Array.prototype.fill        := (args*) => (Arrays.fill(args*))
    Array.prototype.sort        := (args*) => (Arrays.sort(args*))
    ; range easyalign /.=/
  }

  static addMethodsToArrayObjects() {
    explicit_omit := ['prototype', 'fromEnumerator', 'ofLength', 'AddMethods']
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

      f  := desc.call
      fb := f.bind(Arrays)
      desc.call := fb
      
      Array.prototype.defineProp(prop, desc)
    }
  }

}


js_array_prototype_symbols := [
;    "Array.prototype[@@iterator]()",
    "Array.prototype.at()",
    "Array.prototype.concat()",
    "Array.prototype.copyWithin()",
    "Array.prototype.entries()",
    "Array.prototype.every()",
    "Array.prototype.fill()",
    "Array.prototype.filter()",
    "Array.prototype.find()",
    "Array.prototype.findIndex()",
    "Array.prototype.findLast()",
    "Array.prototype.findLastIndex()",
    "Array.prototype.flat()",
    "Array.prototype.flatMap()",
    "Array.prototype.forEach()",
    "Array.from()",
    "Array.fromAsync()",
    "Array.prototype.includes()",
    "Array.prototype.indexOf()",
    "Array.isArray()",
    "Array.prototype.join()",
    "Array.prototype.keys()",
    "Array.prototype.lastIndexOf()",
    "Array.prototype.map()",
    "Array.of()",
    "Array.prototype.pop()",
    "Array.prototype.push()",
    "Array.prototype.reduce()",
    "Array.prototype.reduceRight()",
    "Array.prototype.reverse()",
    "Array.prototype.shift()",
    "Array.prototype.slice()",
    "Array.prototype.some()",
    "Array.prototype.sort()",
    "Array.prototype.splice()",
    "Array.prototype.toLocaleString()",
    "Array.prototype.toReversed()",
    "Array.prototype.toSorted()",
    "Array.prototype.toSpliced()",
    "Array.prototype.toString()",
    "Array.prototype.unshift()",
    "Array.prototype.values()",
    "Array.prototype.with()"
]

fn_todo() {
  for i, sym in js_array_prototype_symbols {
    subs := StrSplit(sym, ['.', '()'])
    method := subs[3] ? subs[3] : subs[2]
    arr := []
    if not Arrays.hasMethod(method) {
      conio.println("Arrays (" i "): " method)
    }
    if not arr.hasMethod(method) {
      conio.println("[] (" i "): " method)
    }
  }
}

