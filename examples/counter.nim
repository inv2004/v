import vecs
import vecs/avx2

var a = initV[byte](1000000)
for i in 0..a.high:
  a[i] = byte((10 + i div 200) mod 100)

# let maskHigh = set1_epi8(3)
# let ymm = loadu_byte(addr a[0])
# echo popcnt_u32 movemask_epi8 cmpgt_epi8(ymm, maskHigh)

# let v = randV(32, byte(4)..byte(200))
# echo a
echo a.counterCheck()
echo a.counter()

