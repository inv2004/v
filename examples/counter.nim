import vecs
import vecs/avx2

var a = initV[byte](32)
for i in 0..a.high:
  a[i] = byte(i div 10)

# let maskHigh = set1_epi8(3)
# let ymm = loadu_byte(addr a[0])
# echo popcnt_u32 movemask_epi8 cmpgt_epi8(ymm, maskHigh)

echo a
echo a.counterCheck()
echo a.counter()

