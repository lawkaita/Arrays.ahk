Util_ThrowsError(fn, expected_error?, expected_message?) {
  ErrorWasThrown := false
  CorrectErrorWasThrown := false
  WithCorrectMessage := false

  try {
    fn()
  } catch as e {
    ErrorWasThrown := true
    CorrectErrorWasThrown := (
      IsSet(expected_error)
      ? (type(e) == expected_error)
      : true
    )
    WithCorrectMessage := (
      IsSet(expected_message)
      ? e.message == expected_message
      : true
    )

    if (debug.ThrowsError) {
      Conio.println("ThrowsError catch block")
      Conio.println("type(e) = " type(e))
      Conio.println("e.message = " e.message)
      Conio.println("ThrowsError catch block extra")
      Conio.println("fn.name = " fn.name)
      Conio.println("e.what = " e.what)
      Conio.println("e.extra = " e.extra)
      Conio.println("e.file = " e.file)
      Conio.println("e.line = " e.line)
      Conio.println("e.stack:`n" e.stack)
    }
  }

  return (ErrorWasThrown and CorrectErrorWasThrown and WithCorrectMessage)
}
