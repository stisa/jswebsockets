JsWebsockets
----

Beginning of a wrapper for websockets, for the javascript backend of [nim](https://nim-lang.org)
  
[Examples](http://stisa.space/jswebsockets)  

[Generated Docs](http://stisa.space/jswebsockets/jswebsockets.html)

**NOTE**: The `append` proc is only exported when compiling with `-d:test`.

```nim
import jswebsockets

var ws = openws("ws://echo.websocket.org/")
var outputid = "output" # convenience for appending

ws.onopen = proc(e:Event) =
  outputid.append("sent: test")
  ws.send("test")
ws.onmessage = proc(e:MessageEvent) =
  outputid.append("received: ",e.data)
  ws.close(StatusCode(1000),"received msg")
ws.onclose = proc(e:CloseEvent) =
  outputid.append("closing: ",e.reason)
```

