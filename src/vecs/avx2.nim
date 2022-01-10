{.passC: "-mavx2".}
{.passL: "-mavx2".}

import avx
export avx

proc cmpeq_epi8*(a, b: m256i): m256i
  {.importc: "_mm256_cmpeq_epi8", header: "immintrin.h".}

proc movemask_epi8*(a: m256i): int32
  {.importc: "_mm256_movemask_epi8", header: "immintrin.h".}

proc extract_epi8*(a: m256i, off: int): byte
  {.importc: "_mm256_extract_epi8", header: "immintrin.h".}

proc cmpgt_epi8*(a, b: m256i): m256i
  {.importc: "_mm256_cmpgt_epi8", header: "immintrin.h".}
