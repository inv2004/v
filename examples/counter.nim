import vecs
import tables

type Tbl = object
  v: seq[byte]

type Parted = seq[(int16, Tbl)]

const P = 365
const N = 380000

var tbl: Parted
for y in 1..P:
  tbl.add (2000+int16(y), Tbl(v: randV(N, byte(1)..byte(2))))

echo tbl.counter()
