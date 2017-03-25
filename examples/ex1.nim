import ../src/jswebsockets

var socket = newWebSocket("ws://echo.websocket.org/")
var outputid = "output" # nicer syntax for appending

socket.onOpen = proc (event: Event) =
  outputid.append("sent: test")
  socket.send("test")
socket.onMessage = proc (event: MessageEvent) =
  outputid.append("received: ", event.data)
  socket.close(scNormal,"received msg")
socket.onClose = proc (event: CloseEvent) =
  outputid.append("closing: ", event.reason)

