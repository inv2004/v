import vecs

import criterion

const N = 9_710_124

var cfg = newDefaultConfig()
cfg.brief = true
cfg.verbose = true
cfg.minSamples = 10

let v2 = randV(N, byte(1)..byte(2))
let v10 = randV(N, byte(1)..byte(10))
let v100 = randV(N, byte(1)..byte(100))
var v200 = initV[byte](N)
for i in 0..v200.high:
  v200[i] = byte((10 + i div 200) mod 100)

benchmark cfg:
  proc counterV2() {.measure.} =
    assert v2.counterCheck().sum() == N
  proc counterV2AVX2() {.measure.} =
    assert v2.counter().sum() == N
  proc counterV10() {.measure.} =
    assert v10.counter().sum() == N
  proc counterV10AVX2() {.measure.} =
    assert v10.counter().sum() == N
  proc counterV100() {.measure.} =
    assert v100.counter().sum() == N
  proc counterV100AVX2() {.measure.} =
    assert v100.counter().sum() == N
  proc counterV200() {.measure.} =
    assert v200.counter().sum() == N
  proc counterV200AVX2() {.measure.} =
    assert v200.counter().sum() == N
