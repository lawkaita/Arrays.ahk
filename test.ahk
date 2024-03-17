#requires autohotkey v2.0
#SingleInstance Force
#Include *i localconf.ahk

#Include <v2\YUnit-2\Yunit>
#Include <v2\YUnit-2\Window>
#Include <v2\throwsError\ThrowsError>

#include "Arrays_apply.ahk"

All_Tests := []

#include "test\"

#include "arrays.ahk"
#include "equals.ahk"
#include "map.ahk"
#include "filter.ahk"
#include "reduce.ahk"
#include "reduceRight.ahk"
#include "forEach.ahk"
#include "join.ahk"
#include "every.ahk"
#include "slice.ahk"
#include "toString.ahk"
#include "splice.ahk"
#include "indexOf.ahk"
#include "lastIndexOf.ahk"
#include "fill.ahk"
#include "sort.ahk"
#include "concat.ahk"
#include "fromEnumerator.ahk"
#include "flat.ahk"
#include "flatMap.ahk"
#include "copyWithin.ahk"
#include "findIndex.ahk"
#include "includes.ahk"
#include "reverse.ahk"
#include "shift.ahk"
#include "unshift.ahk"
#include "entries.ahk"

; include last
#include "_end.ahk"

#include *i ..\test_todo.ahk

Yunit.Use(YunitWindow).Test(All_Tests*)

