module DecodeAsync where

import Prelude

import Audio.WebAudio.AudioBufferSourceNode (StartOptions, setBuffer, startBufferSource)
import Audio.WebAudio.BaseAudioContext (createBufferSource, currentTime, decodeAudioDataAsync, destination, newAudioContext)
import Audio.WebAudio.Types (AudioContext, AudioBuffer, connect, Seconds)
import Control.Parallel (parallel, sequential)
import Data.Array ((!!))
import Data.Either (Either(..))
import Data.HTTP.Method (Method(..))
import Data.Maybe (Maybe(..))
import Data.Traversable (traverse)
import Effect (Effect)
import Effect.Aff (Aff, Fiber, launchAff)
import Effect.Class (liftEffect)
import Network.HTTP.Affjax (affjax, defaultRequest)
import Network.HTTP.Affjax.Response as Response

type ElapsedTime = Number

-- | load a single sound buffer resource and decode it
loadSoundBuffer
  :: AudioContext
  -> String
  -> Aff AudioBuffer
loadSoundBuffer ctx filename = do
  res <- affjax Response.arrayBuffer $ defaultRequest { url = filename, method = Left GET }
  buffer <- decodeAudioDataAsync ctx res.response
  pure buffer

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

main :: Effect (Fiber Unit)
main = launchAff $ do
  ctx <- liftEffect newAudioContext
  buffers <- loadSoundBuffers ctx ["hihat.wav", "kick.wav", "snare.wav"]
  _ <- liftEffect $ playSoundAt ctx (buffers !! 0) 0.0
  _ <- liftEffect $ playSoundAt ctx (buffers !! 1) 0.5
  _ <- liftEffect $ playSoundAt ctx (buffers !! 2) 1.0
  _ <- liftEffect $ playSoundAt ctx (buffers !! 0) 1.5
  _ <- liftEffect $ playSoundAt ctx (buffers !! 1) 2.0
  _ <- liftEffect $ playSoundAt ctx (buffers !! 2) 2.5
  pure unit
