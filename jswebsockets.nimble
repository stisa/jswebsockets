# Package
version       = "0.1.3"
author        = "stisa"
description   = "Wrapper for js websockets"
license       = "MIT"

srcDir = "src"
skipDirs = @["templates"]
# Deps
requires: "nim >= 0.16.0"
import ospaths

task docs, "Build docs":
  mkdir "docs"
  exec("nim doc2 --verbosity:0 --hints:off -o:" & "docs"/"jswebsockets.html " & "."/"src"/"jswebsockets.nim")

task examples, "Build examples":
  exec("exampler")
  mkdir "docs"/"examples"
  withdir "examples":
    for file in listfiles("."):
      if splitfile(file).ext == ".nim":
        exec "nim js -d:test --verbosity:0 --hints:off -o:" & ".."/"docs"/"examples"/ file.changefileext("js") & " " & file
