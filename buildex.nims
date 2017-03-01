import ospaths

exec("../exampler/exampler")
withdir "examples":
  for file in listfiles("."):
    if splitfile(file).ext == ".nim":
      exec "nim js -d:test -o:../docs/examples/"&file.changefileext("js")&" "&file
