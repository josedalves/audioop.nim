version       = "0.0.1"
author        = "josedalves"
description   = "audioop.nim - basic sound stream reading, writing and manipulations"
license       = "MIT"

# Dependencies
requires "nim >= 0.17.2"

when defined(nimdistros):
  import distros
  foreignDep "libsndfile"
  foreignDep "libsamplerate"

