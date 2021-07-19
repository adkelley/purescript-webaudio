module DecodeAsync where

import Prelude

import Affjax (defaultRequest, request)
import Affjax.ResponseFormat as ResponseFormat
import Audio.WebAudio.AudioBufferSourceNode (StartOptions, setBuffer, startBufferSource)
import Audio.WebAudio.BaseAudioContext (createBufferSource, currentTime, decodeAudioDataAsync, destination, newAudioContext)
import Audio.WebAudio.Types (AudioContext, AudioBuffer, connect, Seconds)
import Control.Parallel (parallel, sequential)
import Data.Array ((!!))
import Data.ArrayBuffer.ArrayBuffer (empty)
import Data.Either (Either(..))
import Data.HTTP.Method (Method(..))
import Data.Maybe (Maybe(..))
import Data.Newtype (wrap)
import Data.Traversable (traverse)
import Effect (Effect)
import Effect.Aff (Aff, Fiber, launchAff)
import Effect.Class (liftEffect)
import Effect.Exception (throw)
import Unsafe.Coerce (unsafeCoerce)
import Web.DOM.ParentNode (querySelector)
import Web.Event.EventTarget (EventTarget, addEventListener, eventListener)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toParentNode)
import Web.HTML.Window (document)

type ElapsedTime = Number

-- | load a single sound buffer resource and decode it
loadSoundBuffer
  :: AudioContext
  -> String
  -> Aff AudioBuffer
loadSoundBuffer ctx filename = do
  res <- request $ defaultRequest
               { url = filename, method = Left GET, responseFormat = ResponseFormat.arrayBuffer }
  -- res <- affjax Response.arrayBuffer $ defaultRequest { url = filename, method = Left GET }
  case res <#> _.body of
    Left _ -> do
      emptyBuffer <- liftEffect $ empty 0
      decodeAudioDataAsync ctx emptyBuffer
    Right body -> do
      decodeAudioDataAsync ctx body

-- | load and decode an array of audio buffers from a set of resources
loadSoundBuffers
  :: AudioContext
  -> Array String
  -> Aff (Array AudioBuffer)
loadSoundBuffers ctx fileNames =
  sequential $ traverse (\name -> parallel (loadSoundBuffer ctx name)) fileNames

whenOption :: Seconds → StartOptions
whenOption sec = { when: Just sec,  offset: Nothing, duration: Nothing }

-- | Play a sound at a sepcified elapsed time
playSoundAt
  :: AudioContext
  -> Maybe AudioBuffer
  -> ElapsedTime
  -> Effect Unit
playSoundAt ctx mbuffer elapsedTime =
  case mbuffer of
    Just buffer ->
      do
        startTime <- currentTime ctx
        src <- createBufferSource ctx
        dst <- destination ctx
        _ <- connect src dst
        _ <- setBuffer buffer src
        -- // We'll start playing the sound 100 milliseconds from "now"
        startBufferSource (whenOption (startTime + elapsedTime + 0.1)) src
    _ ->
      pure unit

loadPlayBuffers :: Effect (Fiber Unit)
loadPlayBuffers = launchAff $ do
  ctx <- liftEffect newAudioContext
  buffers <- loadSoundBuffers ctx ["hihat.wav", "kick.wav", "snare.wav"]
  _ <- liftEffect $ playSoundAt ctx (buffers !! 0) 0.0
  _ <- liftEffect $ playSoundAt ctx (buffers !! 1) 0.5
  _ <- liftEffect $ playSoundAt ctx (buffers !! 2) 1.0
  _ <- liftEffect $ playSoundAt ctx (buffers !! 0) 1.5
  _ <- liftEffect $ playSoundAt ctx (buffers !! 1) 2.0
  _ <- liftEffect $ playSoundAt ctx (buffers !! 2) 2.5
  pure unit

main :: Effect Unit
main = do
  doc <- map toParentNode (window >>= document)
  playButton <- querySelector (wrap "#play") doc
  case playButton of
    Just e -> do
      el <- eventListener \_ -> loadPlayBuffers
      addEventListener (wrap "click") el false (unsafeCoerce e :: EventTarget)
    Nothing -> throw "no play button"
