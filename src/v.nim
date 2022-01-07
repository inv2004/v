import random
import tables

proc initV*[T](x: int): seq[T] =
  newSeq[T](x)

proc randV*[T](x:int): seq[T] =
  result = newSeq[T](x)
  for x in result.mitems:
    x = rand(T)

proc randV*[T](x:int, max: T): seq[T] =
  result = newSeq[T](x)
  for x in result.mitems:
    x = rand(0.max max - 1)

proc randV*[T](x:int, r: HSlice[T, T]): seq[T] =
  result = newSeq[T](x)
  for x in result.mitems:
    x = rand(r)

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

type Counter*[T] = object
  when T is byte:
    flat256: array[256, int]
  else:
    ct: CountTable[T]

proc initCounter*[T: byte](t: openArray[(T, int)]): Counter[T] =
  for (idx, v) in t:
    result.flat256[idx] = v

proc initCounter*[T](t: openArray[(T, int)]): Counter[T] =
  for (x, v) in t:
    result.ct.inc(x, v) 

proc `$`*[T: byte](c: Counter[T]): string =
  result.add '{'
  for i, x in c.flat256:
    if x > 0:
      if result.len > 1: result.add ", "
      result.add $i & ": " & $x
  result.add '}'

proc count*[T: byte](x: openArray[T]): Counter[T] =
  for x in x:
    inc result.flat256[x]

proc `$`*[T](c: Counter[T]): string =
  $c.ct



proc count*[T](x: openArray[T]): Counter[T] =
  Counter[T](ct: x.toCountTable)

proc `[]`*[T](c: Counter[T], x: T): int =
  tables.`[]`(c, x)
