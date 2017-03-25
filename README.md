JsWebsockets
----

Beginning of a wrapper for websockets, for the javascript backend of [nim](https://nim-lang.org)
  
[Examples](http://stisa.space/jswebsockets)  

[Generated Docs](http://stisa.space/jswebsockets/jswebsockets.html)

```nim
import jswebsockets

var
  socket = newWebSocket("ws://echo.websocket.org/")

socket.onOpen = proc (e:Event) =
  echo("sent: test")
  socket.send("test")
socket.onMessage = proc (e:MessageEvent) =
  echo("received: ",e.data)
  socket.close(StatusCode(1000),"received msg")
socket.onClose = proc (e:CloseEvent) =
  echo("closing: ",e.reason)
```

