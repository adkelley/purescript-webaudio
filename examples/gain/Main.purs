module Gain where

import Prelude

import Audio.WebAudio.AudioBufferSourceNode (defaultStartOptions, setBuffer, startBufferSource)
import Audio.WebAudio.BaseAudioContext (createGain, createBufferSource, decodeAudioData, destination, newAudioContext)
import Audio.WebAudio.AudioParam (setValueAtTime)
import Audio.WebAudio.GainNode (gain)
import Audio.WebAudio.Types (AudioBuffer, AudioBufferSourceNode, connect)
import Data.ArrayBuffer.Types (ArrayBuffer)
import Data.Newtype (wrap)
import Effect (Effect)
import Effect.Console (warn)
import Effect.Exception (throw)
import SimpleDom (DOMEvent, HttpData(..), HttpMethod(..), ProgressEventType(..)
                 , XMLHttpRequest, addProgressEventListener, makeXMLHttpRequest, open
                 , response, send, setResponseType)
import Partial.Unsafe (unsafePartial)
import Unsafe.Coerce (unsafeCoerce)
import Web.DOM.ParentNode (querySelector)
import Web.Event.EventTarget (EventTarget, addEventListener, eventListener)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toParentNode)
import Web.HTML.Window (document)
import Data.Maybe (Maybe(..))

toArrayBuffer :: forall a. (HttpData a) -> ArrayBuffer
toArrayBuffer hd =
  unsafePartial
    case hd of
      (ArrayBufferData a) -> a

-- | 3 secs after the audio begins playing, set the value (i.e., volume)
-- | of the gain node to 0.3 (i.e., a 70% reduction)

play :: XMLHttpRequest -- |^ the request object
     -> DOMEvent -- |^ the load event
     -> Effect Unit
play req _ = do
  ctx <- newAudioContext
  src <- createBufferSource ctx
  gainNode <- createGain ctx
  dst <- destination ctx
  connect src gainNode
  connect gainNode dst
  gainParam <- gain gainNode
  _ <- setValueAtTime 0.3 3.0 gainParam
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
  open GET "gain.wav" req
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
    Nothing -> throw "no play button"
