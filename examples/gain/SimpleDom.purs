module SimpleDom (DOMEvent, HttpData(..), HttpMethod(..), ProgressEventType(..), XMLHttpRequest
                 , class ProgressEventTarget, class ProgressEvent, class Event, eventTarget, addProgressEventListener
                 , progressEventType, makeXMLHttpRequest, open, response, send, setResponseType) where


-- Ported necessary components from https://github.com/aktowns/purescript-simple-dom
-- to run Test03 only

import Prelude

import Effect (Effect)
import Data.ArrayBuffer.Types (ArrayBuffer)
import Data.Function.Uncurried (Fn2, Fn3, Fn1, runFn1, runFn2, runFn3)

type Url = String

data HttpMethod = GET
instance showHttpMethod :: Show HttpMethod where
  show GET = "GET"

data ResponseType = ArrayBuffer | Default
instance showResponseType :: Show ResponseType where
  show ArrayBuffer = "arraybuffer"
  show Default = ""

data ProgressEventType = ProgressLoadEvent
instance showProgressEventType :: Show ProgressEventType where
    show ProgressLoadEvent = "load"
      
data HttpData :: forall k. k -> Type
data HttpData a
  = NoData
  | ArrayBufferData ArrayBuffer
  | TextData String

foreign import maybeFn :: forall a b. Fn3 b (a -> b) a b

foreign import data DOMEvent          :: Type
foreign import data XMLHttpRequest    :: Type
foreign import makeXMLHttpRequest :: Effect XMLHttpRequest
foreign import unsafeOpen :: Fn3 XMLHttpRequest String String (Effect Unit)
foreign import unsafeSend :: Fn1 XMLHttpRequest (Effect  Unit)
foreign import unsafeSendWithPayload :: ∀ a. Fn2 XMLHttpRequest a (Effect  Unit)
foreign import unsafeAddEventListener :: ∀ e b. String -> (e -> Effect Unit) -> b -> Effect Unit
foreign import unsafeEventTarget :: ∀ a. DOMEvent -> Effect a
foreign import unsafeEventProp :: ∀ v. String -> DOMEvent -> Effect v
foreign import unsafeResponseType :: XMLHttpRequest -> Effect String
foreign import unsafeResponse :: ∀ a. XMLHttpRequest -> Effect a
foreign import unsafeSetResponseType :: Fn2 XMLHttpRequest String (Effect Unit)

open :: HttpMethod -> Url -> XMLHttpRequest -> Effect Unit
open m u x = runFn3 unsafeOpen x (show m) u

send :: ∀ a. HttpData a -> XMLHttpRequest -> Effect Unit
send _ x = runFn1 unsafeSend x  -- NoData (GET)

class Event e where
  eventTarget     :: ∀ a. e -> Effect a

instance eventDOMEvent :: Event DOMEvent where
  eventTarget     = unsafeEventTarget

readProgressEventType :: String -> ProgressEventType
readProgressEventType "load"      = ProgressLoadEvent
readProgressEventType _           = ProgressLoadEvent

class (Event e) <= ProgressEvent e where
    progressEventType :: e -> Effect ProgressEventType

instance progressEventDOMEvent :: ProgressEvent DOMEvent where
    progressEventType ev = readProgressEventType <$> unsafeEventProp "type" ev

class ProgressEventTarget b where
    addProgressEventListener :: forall e. (ProgressEvent e) =>
                                ProgressEventType
                                    -> (e -> Effect Unit)
                                    -> b
                                    -> (Effect Unit)


instance progressEventTargetXMLHttpRequest :: ProgressEventTarget XMLHttpRequest where
    addProgressEventListener typ    = unsafeAddEventListener (show typ)

responseType :: XMLHttpRequest -> Effect ResponseType
responseType obj = do
  rt <- unsafeResponseType obj
  pure $ case rt of
    "arraybuffer" -> ArrayBuffer
    _ -> Default

setResponseType :: String -> XMLHttpRequest -> Effect Unit
setResponseType rt xhr = runFn2 unsafeSetResponseType xhr rt

response :: ∀ a. XMLHttpRequest -> Effect (HttpData a)
response xhr = do
  rt <- responseType xhr
  case rt of
    ArrayBuffer           -> get ArrayBufferData
    _                     -> get TextData  -- Default
  where
    get :: ∀ a' b. (a' -> HttpData b) -> Effect (HttpData b)
    get rt = runFn3 maybeFn NoData rt <$> unsafeResponse xhr
