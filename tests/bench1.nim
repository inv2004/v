import vecs

import criterion

# const N = 9_710_124
const P = 365
const N = 380000

var cfg = newDefaultConfig()
cfg.brief = true
cfg.verbose = true
cfg.budget = 1.0
cfg.minSamples = 1

var tbl: seq[(int16, seq[byte])]
for y in 1'i16..P:
  tbl.add (y, randV(N, 0'u8..3'u8))

benchmark cfg:
  proc mergedCounter() {.measure.} =
    doAssert tbl.mergedCounter().sum() == N*P
  # proc averager() {.measure.} =
    # assert
  # proc counterV2() {.measure.} =
  #   assert v2.counterCheck().sum() == N
  # proc counterV2AVX2() {.measure.} =
  #   assert v2.counter().sum() == N
  # proc counterV10() {.measure.} =
  #   assert v10.counter().sum() == N
  # proc counterV10AVX2() {.measure.} =
  #   assert v10.counter().sum() == N
  # proc counterV100() {.measure.} =
  #   assert v100.counter().sum() == N
  # proc counterV100AVX2() {.measure.} =
  #   assert v100.counter().sum() == N
  # proc counterV200() {.measure.} =
  #   assert v200.counter().sum() == N
  # proc counterV200AVX2() {.measure.} =
  #   assert v200.counter().sum() == N
  # proc averagerV2() {.measure.} =
  #   assert v9.averager(f).sum() > 0.0
  # proc counter2() {.measure.} =
  #   assert v2.counter2(v10).len > 0
