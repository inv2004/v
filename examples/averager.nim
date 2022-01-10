import vecs

const N = 10
let v = randV(N, 0'u8..9'u8)
let f = randV(N, 2.3'f32)
echo v
echo f
echo v.averager(f).sum()
echo v.averagerAVX2(f).sum()
