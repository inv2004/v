{.passC: "-msse3 -mssse3 -msse4 -mavx".}
{.passL: "-msse3 -mssse3 -msse4 -mavx".}

import mmx
export mmx

const width* = 32

type m256i* {.importc: "__m256i", header: "immintrin.h".} = object

proc set1_epi8*(b: int8 | uint8): m256i
  {.importc: "_mm256_set1_epi8", header: "immintrin.h".}

proc loadu_byte*(p: ptr byte): m256i
  {.importc: "_mm256_loadu_si256", header: "immintrin.h".}
