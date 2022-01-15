import vecs

const P = 10
const N = 380000

var tbl: seq[(byte, seq[byte])]
for y in 1..P:
  tbl.add (10+byte(y), randV(N, byte(0)..byte(9)))

echo tbl.mergedAverager()
