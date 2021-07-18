module DecodeAudio where

import Prelude

import Audio.WebAudio.AudioBufferSourceNode (defaultStartOptions, setBuffer, startBufferSource)
import Audio.WebAudio.BaseAudioContext (createBufferSource, decodeAudioData, destination, newAudioContext)
import Audio.WebAudio.Types (AudioBuffer, AudioBufferSourceNode, connect)
import Data.ArrayBuffer.Types (ArrayBuffer)
import Data.Maybe (Maybe(..))
import Data.Newtype (wrap)
import Effect (Effect)
import Effect.Console (warn)
import Effect.Exception (throw)
import Partial.Unsafe (unsafePartial)
import SimpleDom (DOMEvent, HttpData(..), HttpMethod(..), ProgressEventType(..), XMLHttpRequest, addProgressEventListener, makeXMLHttpRequest, open, response, send, setResponseType)
import Unsafe.Coerce (unsafeCoerce)
import Web.DOM.ParentNode (querySelector)
import Web.Event.EventTarget (EventTarget, addEventListener, eventListener)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toParentNode)
import Web.HTML.Window (document)


toArrayBuffer :: forall a. (HttpData a) -> ArrayBuffer
toArrayBuffer hd =
  unsafePartial
    case hd of
      (ArrayBufferData a) -> a

play :: XMLHttpRequest -- |^ the request object
     -> DOMEvent -- |^ the load event
     -> Effect Unit
play req _ = do
  ctx <- newAudioContext
  src <- createBufferSource ctx
  dst <- destination ctx
  connect src dst
  audioData <- response req
  decodeAudioData ctx (toArrayBuffer audioData) (play0 src) warn

play0 :: AudioBufferSourceNode
      -> AudioBuffer
      -> Effect Unit
play0 src buf = do
  setBuffer buf src
  startBufferSource defaultStartOptions src

playWavFile :: Effect Unit
playWavFile = do
  req <- makeXMLHttpRequest
  open GET "decode-audio.wav" req
  setResponseType "arraybuffer" req
  addProgressEventListener ProgressLoadEvent (play req) req
  send NoData req
  pure unit

main :: Effect Unit
main = do
  doc <- map toParentNode (window >>= document)
  playButton <- querySelector (wrap "#play") doc
  case playButton of
    Just e -> do
      el <- eventListener \_ -> playWavFile
      addEventListener (wrap "click") el false (unsafeCoerce e :: EventTarget)
    Nothing -> throw "No 'play' button"
  pure unit
