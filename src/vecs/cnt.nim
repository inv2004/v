import avx2

import tables
import unrolled

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
  result.add "Cnb{"
  let initLen = result.len
  for i, x in c.flat256:
    if x > 0:
      if result.len > initLen: result.add ", "
      result.add $i & ": " & $x
  result.add '}'

proc counterCheck*[T: byte](x: openArray[T]): Counter[T] =
  for x in x:
    inc result.flat256[x]

proc counter*[T: byte](x: openArray[T]): Counter[T] =
  let mask0 = set1_epi8(0)
  let mask1 = set1_epi8(1)
  let mask2 = set1_epi8(2)
  let mask3 = set1_epi8(3)
  var i = 0
  while i < x.len-avx.width:
    let ymm = loadu_byte(unsafeAddr x[i])
    let maskRepeat = set1_epi8(x[i])
    if avx.width == popcnt_u32 movemask_epi8 cmpeq_epi8(ymm, maskRepeat):
      result.flat256[x[i]] += avx.width
    elif 0 < popcnt_u32 movemask_epi8 cmpgt_epi8(ymm, mask3):
      unroll for off in 0..<(avx.width):
        result.flat256[extract_epi8(ymm, off)].inc
    else:
      result.flat256[0] += popcnt_u32 movemask_epi8 cmpeq_epi8(ymm, mask0)
      result.flat256[1] += popcnt_u32 movemask_epi8 cmpeq_epi8(ymm, mask1)
      result.flat256[2] += popcnt_u32 movemask_epi8 cmpeq_epi8(ymm, mask2)
      result.flat256[3] += popcnt_u32 movemask_epi8 cmpeq_epi8(ymm, mask3)
    i += avx.width
  for i in i..<x.len:
    result.flat256[x[i]].inc

proc sum*[T: byte](c: Counter[T]): int =
  for x in c.flat256:
    result += x

proc sum*[T](c: Counter[T]): int =
  for x in c.ct.values:
    result += x

proc `$`*[T](c: Counter[T]): string =
  "Cnt" & $c.ct

proc counter*[T](x: openArray[T]): Counter[T] =
  Counter[T](ct: x.toCountTable)

proc `[]`*[T](c: Counter[T], x: T): int =
  tables.`[]`(c, x)
