# Package

version       = "0.1.0"
author        = "alexander"
description   = "Vector processing"
license       = "MIT"
srcDir        = "src"

# Dependencies

requires "nim >= 1.6.2"
requires "zero_functional"
requires "unrolled"

task bench, "bench":
  # exec "nim c -d:danger -r tests/bench1.nim"
  exec """nim c --opt:speed --passC:'-flto -march=native -Ofast' --passL:'-flto -march=native -Ofast' -d:danger -r tests/bench1.nim"""
