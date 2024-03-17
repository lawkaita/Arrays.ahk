#requires autohotkey v2.0
#SingleInstance Force

#Include <v2/YUnit-2/Yunit>
#Include <v2/YUnit-2/Window>
#Include <v2/YUnit-2/StdOut>
#Include <v2/conio>

#Include "util.ahk"
debug := {}
debug.ThrowsError := true

Conio.init("wt").SetWinPosTopRight()

pid := ProcessExist()
#HotIf WinGetPid("A") == pid
Esc::ExitApp
^Enter::Reload
#HotIf

#include "Arrays.ahk"

#include "test"
#include "equals.ahk"
#include "map.ahk"
#include "filter.ahk"
#include "reduce.ahk"
#include "foreach.ahk"
#include "join.ahk"
#include "every.ahk"
#include "slice.ahk"
#include "slice.node.ahk"
#include "toString.ahk"


Yunit.Use(YunitWindow, YUnitStdOut).Test(
  Equals_Tests
  , Map_Tests
  , Filter_Tests
  , Reduce_Tests
  , ForEach_Tests
  , Join_Tests
  , Every_Tests
  , Slice_Tests
  , Slice_Node_Tests
  , ToString_Tests
)

Class Dummy_Tests {

}
