proc popcnt_u32*(a: int32): int32
  {.importc: "_mm_popcnt_u32", header: "immintrin.h".}
