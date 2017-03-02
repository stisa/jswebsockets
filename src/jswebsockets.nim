from dom import Event
export Event

# TODO: finish MessageEvent
# TODO: check if there are missing fields
# TODO: tests


type StatusCode* = enum
  scNormal = 1000
  scGoingAway = 1001
  scProtocolError = 1002
  scUnsupported = 1003
  scReserved = 1004
  scNoStatus = 1005
  scAbnormal = 1006
  scUnsupportedData = 1007
  scPolicyViolation = 1008
  scTooLarge = 1009
  scMissingExt = 1010
  scInternalError = 1011
  scRestart = 1012
  scTryAgainLater = 1013
  scReserved2 = 1014
  scTLSHandshake = 1015

type MessageEvent* {.importc} = object of Event
  data*: cstring

type CloseEvent* {.importc} = object of Event
  ##[
Status code	Name	Description

0–999	 	Reserved and not used.

1000	CLOSE_NORMAL	Normal closure; the connection successfully completed whatever purpose for which it was created.

1001	CLOSE_GOING_AWAY	The endpoint is going away, either because of a server failure or because the browser is navigating away from the page that opened the connection.

1002	CLOSE_PROTOCOL_ERROR	The endpoint is terminating the connection due to a protocol error.

1003	CLOSE_UNSUPPORTED	The connection is being terminated because the endpoint received data of a type it cannot accept (for example, a text-only endpoint received binary data).

1004	 	Reserved. A meaning might be defined in the future.

1005	CLOSE_NO_STATUS	Reserved.  Indicates that no status code was provided even though one was expected.

1006	CLOSE_ABNORMAL	Reserved. Used to indicate that a connection was closed abnormally (that is, with no close frame being sent) when a status code is expected.

1007	Unsupported Data	The endpoint is terminating the connection because a message was received that contained inconsistent data (e.g., non-UTF-8 data within a text message).

1008	Policy Violation	The endpoint is terminating the connection because it received a message that violates its policy. This is a generic status code, used when codes 1003 and 1009 are not suitable.

1009	CLOSE_TOO_LARGE	The endpoint is terminating the connection because a data frame was received that is too large.

1010	Missing Extension	The client is terminating the connection because it expected the server to negotiate one or more extension, but the server didn't.

1011	Internal Error	The server is terminating the connection because it encountered an unexpected condition that prevented it from fulfilling the request.

1012	Service Restart	The server is terminating the connection because it is restarting. [Ref]

1013	Try Again Later	The server is terminating the connection due to a temporary condition, e.g. it is overloaded and is casting off some of its clients. [Ref]

1014	 	Reserved for future use by the WebSocket standard.

1015	TLS Handshake	Reserved. Indicates that the connection was closed due to a failure to perform a TLS handshake (e.g., the server certificate can't be verified).

1016–1999	 	Reserved for future use by the WebSocket standard.

2000–2999	 	Reserved for use by WebSocket extensions.

3000–3999	 	Available for use by libraries and frameworks. May not be used by applications. Available for registration at the IANA via first-come, first-serve.

4000–4999	 	Available for use by applications.

]##
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
proc close*(ws:WebSocket,code:StatusCode|Natural,reason:cstring){.importcpp}

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

