# Package

version       = "0.1.0"
author        = "alexander"
description   = "Vector processing"
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 1.6.2"
requires "zero_functional"

task bench, "bench":
  exec "nim c -d:release -r tests/bench1.nim"