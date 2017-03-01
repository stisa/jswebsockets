from dom import Event
export Event

#TODO: enum for close code https://developer.mozilla.org/en-US/docs/Web/API/CloseEvent

type MessageEvent* {.importc} = object of Event
  data*: cstring

type CloseEvent* {.importc} = object of Event
  code*: Natural
  reason*: cstring
  wasClean*: bool

type WebSocketObj {.importc } = ref object of RootObj
  url*: cstring
  protocols*: seq[cstring] #use enum?
  onopen*,onerror*: proc(e:Event)
  readyState*: int
  onclose*: proc(e:CloseEvent)
  onmessage*: proc(e:MessageEvent)

type WebSocket* = object of WebsocketObj

proc openws*(url:cstring):WebSocket {.importcpp: "new WebSocket(#)"}

proc openws*(url:string,protocols:seq[string]):WebSocket {.importcpp: "new WebSocket(#,@)"}

proc send*(ws:WebSocket,data:cstring){.importcpp}

proc close*(ws:WebSocket){.importcpp}
proc close*(ws:WebSocket,code:Natural,reason:cstring){.importcpp}

#[ Convenience ]#
when defined test:
  import dom
  from strutils import join
  proc append*(toID:string = "output",s:varargs[string, `$`]) =
    ## Convenience to append to a specific id
    ## Basically ``echo`` for the js target, but allows to specify where to append to
    var p = document.createelement("P")
    p.innerHtml = s.join
    let parent = document.getElementById(toID)
    parent.appendChild(p)

when ismainmodule:
  var ws = openws("ws://echo.websocket.org/")

  ws.onopen = proc(e:Event) =
    echo("sent: test")
    ws.send("test")
  ws.onmessage = proc(e:MessageEvent) =
    echo("received: ",e.data)
    ws.close(1000,"received msg")
  ws.onclose = proc(e:CloseEvent) =
    echo("closing: ",e.reason)

