class Arrays {

  static _variadic_call(fn, l*) {
    ; this function only ever should receive calls from Arrays methods
    ; so it should never be called with more than 3-4 arguments in l*.
    if (type(fn) == 'BoundFunc') {
      failpointer := {}
      res := failpointer
      ; try to call the function fn with argument list l* until it succees
      ; or we run out of arguments.
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
        throw Error('Malformed function passed to Arrays method.')
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
    expected_message := 'Too many parameters passed to function.'
    expected_what := ''
    expected_stack_first_line_substring := ' : [Arrays._variadic_call] '
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
    case_sense := true
    if not InStr(stack_first_line, expected_stack_first_line_substring, case_sense) {
      return false
    }
    return true
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
      if isSet(initial) {
	return initial
      }
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

  ; Arrays.slice first attempt thoughts:
  ;
  ; ahk arrays are 1-based, so
  ; shift every value in the range tests by +1
  ; compared to the js range logic.
  ; as a result, 0 is the last index
  ;
  ; in js 
  ; a is inclusive, b is exclusive.
  ;
  ; here
  ; both are inclusive
  ; or else arr.slice(0,1) yields [], which
  ; may not be what the user wanted
  ;
  ; altough this is the same as arr.slice(-1,0) in js
  ; does that make sense?
  ;
  ; since b is inclusive, substract 1 from
  ; all b range logic
  ; except if < -l.length, then b is 0,
  ; which now means less than any possible a
  ;
  ; also allow b = 0 in first range test,
  ; meaning last index

  /*
    - ahk arrays are 1-based.
    - ahk arrays allow negative indexing:
        - a[-1] is the last element of a.
        - a[-a.length] is the first element.

    therefore, to stay consistent with ahk
    indexing,  -1 should not mean the second
    last index, and 0 should not mean the last
    index.

    in js array.slice(a,b),
      - a is inclusive,
      - b is exclusive.

    since ahk is 1-based, the b in 
    Arrays.slice(l,a,b) should also
    be inclusive.

    a = 0 is considered an error?
    b = 0 is not?

    if b is fixed
      if a approaches 0 from above
	 a = 0 makes sense as a = 1
           return all up to b
      if a approaches 0 from below
	 a = 0 makes sense as a = l.length + 1
           return nothing

    if a is fixed
      if b approaches 0 from above
         b = 0 makes sense as b < a
           return nothing
      if b approaches 0 from below
         b = 0 makes sense as b = l.length
           return all starting form a
   

  */
  static slice(l, a:=1, b?) {
    _l := []

    if (a == 0)
      return _l

    if (-l.length <= a and a < 0)
      /*
        - a is in  [-l.length, -1]
        - map a to [1,   l.length]
        this is the same transformation
        that ahk itself does with
        negative indexes.
      */
      a := a + l.length + 1
    else if (a < -l.length)
      a := 1
    else if (a > l.length)
      return _l

    /*
      
    */
    if not (isSet(b))
      b := l.length
    else if (b == 0)
      return _l
    else if (-l.length <= b and b < 0)
      b := b + l.length + 1
    else if (b < -l.length)
      b := 0
    else if (b > l.length)
      b := l.length

    if (b < a)
      return _l

    i := a
    while (i <= b) {
      _l.push(l[i])
      i++
    }
    return _l
  }

  static splice(l, a?, delcount?, items*) { 
    _l := []

    if not (isSet(a)) {
      if (not (isSet(b)) and (items.length == 0)) {
        return _l
      } else {
        a := 1
      }
    }

    if (-l.length + 1 <= a and a < 1)
      a := a + l.length
    else if (a < -l.length + 1)
      a := 1
    else if (a >= l.length + 1)
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

}

Array.prototype.equals	 := (args*) => (Arrays.equals(args*))
Array.prototype.map	 := (args*) => (Arrays.map(args*))
Array.prototype.filter	 := (args*) => (Arrays.filter(args*))
Array.prototype.reduce	 := (args*) => (Arrays.reduce(args*))
Array.prototype.join	 := (args*) => (Arrays.join(args*))
Array.prototype.forEach	 := (args*) => (Arrays.forEach(args*))
Array.prototype.slice    := (args*) => (Arrays.slice(args*))
Array.prototype.every    := (args*) => (Arrays.every(args*))
Array.prototype.toString := (args*) => (Arrays.toString(args*))

