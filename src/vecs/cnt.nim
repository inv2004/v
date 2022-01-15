import avx2

import tables
import unrolled
import meow

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

proc counter*[T: byte](a: openArray[T]): Counter[T] =
  let mask0 = set1_epi8(0)
  let mask1 = set1_epi8(1)
  let mask2 = set1_epi8(2)
  let mask3 = set1_epi8(3)
  var i = 0
  while i < a.len-avx.width:
    let ymm = loadu_byte(unsafeAddr a[i])
    let maskRepeat = set1_epi8(a[i])
    # if avx.width == popcnt_u32 movemask_epi8 cmpeq_epi8(ymm, maskRepeat):
    #   result.flat256[a[i]] += avx.width
    if 0 < popcnt_u32 movemask_epi8 cmpgt_epi8(ymm, mask3):
      unroll for off in 0..<(avx.width):
        result.flat256[extract_epi8(ymm, off)].inc
    else:
      result.flat256[0] += popcnt_u32 movemask_epi8 cmpeq_epi8(ymm, mask0)
      result.flat256[1] += popcnt_u32 movemask_epi8 cmpeq_epi8(ymm, mask1)
      result.flat256[2] += popcnt_u32 movemask_epi8 cmpeq_epi8(ymm, mask2)
      result.flat256[3] += popcnt_u32 movemask_epi8 cmpeq_epi8(ymm, mask3)
    i += avx.width
  for i in i..<a.len:
    result.flat256[a[i]].inc

proc sum*[T: byte](c: Counter[T]): int =
  for x in c.flat256:
    result += x

proc sum*[T](c: Counter[T]): int =
  for x in c.ct.values:
    result += x

proc `$`*[T](c: Counter[T]): string =
  "Cnt" & $c.ct

proc len*[T](c: Counter[T]): int =
  c.ct.len

proc mergedCounter*[T:byte;P;S:seq[T]|array[int,T]](a: openArray[(P, S)]): Counter[T] =
  for (_, t) in a:
    for i, v in counter(t).flat256:
      result.flat256[i] += v

proc mergedCounter*[T:not byte;P;S:seq[T]|array[int,T]](a: openArray[(P, S)]): Counter[T] =
  for (p, t) in a:
    for i, v in counter(t).flat256:
      result.ct.inc(byte(i), v)

proc counter*[T:byte;P;S:seq[T]|array[int,T]](a: openArray[(P, S)]): Counter[(P,T)] =
  for (p, t) in a:
    for i, v in counter(t).flat256:
      if v > 0:
        result.ct.inc((p, byte(i)), v)

proc counter*[T:not byte;P;S:seq[T]|array[int,T]](a: openArray[(P, S)]): Counter[(P,T)] =
  for (p, t) in a:
    for r, v in counter(t).ct:
      result.ct.inc((p, r), v)

proc counter*[T:not tuple](a: openArray[T]): Counter[T] =
  Counter[T](ct: a.toCountTable)
