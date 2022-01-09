import c

import random
import tables

proc initV*[T](x: int): seq[T] =
  newSeq[T](x)

proc initV*[T](x: int, def: T): seq[T] =
  result = newSeq[T](x)
  for x in result.mitems:
    x = def

proc randV*[T](x:int, r: Slice[T]): seq[T] =
  result = newSeq[T](x)
  for x in result.mitems:
    x = rand(r)

proc randV*[T](x:int, v: T): seq[T] =
  result = newSeq[T](x)
  for x in result.mitems:
    x = rand(v)

proc checkLen[T, G](a: openArray[T], b: openArray[G]) =
  if a.len != b.len:
    raise newException(ValueError, "len")

template math(opn: untyped, op: untyped) =
  proc opn*[T](a, b: openArray[T]): seq[T] =
    checkLen(a, b)
    result = newSeq[T](a.len)
    for i, x in a:
      result[i] = op(x, b[i])

  proc opn*[T](a: T, b: openArray[T]): seq[T] =
    result = newSeq[T](b.len)
    for i, x in b:
      result[i] = op(a, x)

  proc opn*[T](a: openArray[T], b: T): seq[T] =
    result = newSeq[T](a.len)
    for i, x in a:
      result[i] = op(x, b)

  proc opn*[T: not SomeFloat; G: SomeFloat](a: openArray[T], b: openArray[G]): seq[G] =
    checkLen(a, b)
    result = newSeq[G](a.len)
    for i, x in a:
      result[i] = op(x.G, b[i])

  proc opn*[T: SomeFloat; G: not SomeFloat](a: openArray[T], b: openArray[G]): seq[T] =   # optimize via template
    opn(b, a)

math(`+`, `+`)
math(`-`, `-`)
math(`*`, `*`)
math(`/`, `/`)

template compare1(opn: untyped, op: untyped) =
  proc opn*[T](a: openArray[T], b: T): bool =
    for x in a:
      if not op(x, b): return false
    true

template compare2(opn: untyped, op: untyped) =
  proc opn*[T](a: T, b: openArray[T]): bool =
    for x in a:
      if not op(a, x): return false
    true

compare1(`*>`, `>`)
compare1(`*>=`, `>=`)
compare1(`*<`, `<`)
compare1(`*<=`, `<=`)
compare2(`<*`, `<`)
compare2(`<=*`, `<=`)
compare2(`>*`, `>`)
compare2(`>=*`, `>=`)

proc sum*[T: SomeNumber](x: openArray[T]): int =
  for x in x:
    result += x.int
