import tables

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
  result.add "b{"
  let initLen = result.len
  for i, x in c.flat256:
    if x > 0:
      if result.len > initLen: result.add ", "
      result.add $i & ": " & $x
  result.add '}'

proc count*[T: byte](x: openArray[T]): Counter[T] =
  for x in x:
    inc result.flat256[x]

proc sum*[T: byte](c: Counter[T]): int =
  for x in c.flat256:
    result += x

proc sum*[T](c: Counter[T]): int =
  for x in c.ct.values:
    result += x

proc `$`*[T](c: Counter[T]): string =
  $c.ct

proc count*[T](x: openArray[T]): Counter[T] =
  Counter[T](ct: x.toCountTable)

proc `[]`*[T](c: Counter[T], x: T): int =
  tables.`[]`(c, x)
