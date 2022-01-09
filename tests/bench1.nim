import vecs

import criterion

const N = 10_000_000

var cfg = newDefaultConfig()
cfg.brief = true
cfg.verbose = true
cfg.minSamples = 10

let x = randV(10, byte(1)..byte(2))
echo x

# benchmark cfg:
#   proc bench10mCount() {.measure.} =
#     assert x.count().sum() == N
