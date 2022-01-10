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
  # proc benchV2Count() {.measure.} =
  #   assert v2.count.sum() == N
  proc benchV2CountAVX2V1() {.measure.} =
    assert v2.countAVX2V1().sum() == N
  proc benchV2CountAVX2V2() {.measure.} =
    assert v2.countAVX2V2().sum() == N
  # proc benchV10Count() {.measure.} =
  #   assert v10.count.sum() == N
  proc benchV10CountAVX2V1() {.measure.} =
    assert v10.countAVX2V1().sum() == N
  proc benchV10CountAVX2V2() {.measure.} =
    assert v10.countAVX2V2().sum() == N
  # proc benchV100Count() {.measure.} =
  #   assert v100.count.sum() == N
  proc benchV100CountAVX2V1() {.measure.} =
    assert v100.countAVX2V1().sum() == N
  proc benchV100CountAVX2V2() {.measure.} =
    assert v100.countAVX2V2().sum() == N
  # proc benchV200Count() {.measure.} =
  #   assert v200.count().sum() == N
  proc benchV200CountAVX2V1() {.measure.} =
    assert v200.countAVX2V1().sum() == N
  proc benchV200CountAVX2V2() {.measure.} =
    assert v200.countAVX2V2().sum() == N
