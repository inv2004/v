import tables

type Averager*[T,G] = object
  when T is byte:
    flat256: array[256, int]
    flat256s: array[256, G]
  else:
    ct: Table[T, (G, int)]

proc `$`*[T,G](a: Averager[T,G]): string =
  result.add "Avg{"
  let initRes = result.len
  for (k, v) in a.ct.pairs:
    if result.len > initRes: result.add ", "
    result.add $k & ": " & $(v[0] / float(v[1]))
  result.add "}"

proc averagerCheck*[T,G](a: openArray[T], b: openArray[G]): Averager[T,G] =
  for i, x in a:
    if x notin result.ct:
      result.ct[x] = (b[i], 1)
    else:
      result.ct[x][0] += b[i]
      result.ct[x][1].inc

proc averager*[T: byte, G](a: openArray[T], b: openArray[G]): Averager[T,G] =
  for i, x in a:
    result.flat256[x].inc
    result.flat256s[x] += b[i]

proc sum*[T: byte; G](c: Averager[T,G]): G =
  for i, s in c.flat256s:
    if c.flat256[i] > 0:
      result += s / G(c.flat256[i])

proc sum*[T,G](c: Averager[T,G]): float =
  for (a, c) in c.ct.values:
    result += a / float(c)
