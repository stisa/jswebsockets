# Package
version       = "0.1.0"
author        = "stisa"
description   = "Wraps js websockets"
license       = "MIT"

# Deps
requires: "nim >= 0.14.0"

task docs:
  exec("nim doc2 -o:docs/websockets.html websockets.nim")
  exec("nim e buildex.nims")
task exampler:
  exec("nim e buildex.nims")
