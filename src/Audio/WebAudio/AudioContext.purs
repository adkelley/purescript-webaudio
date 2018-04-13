module Audio.WebAudio.AudioContext
  ( makeAudioContext, createOscillator, createGain, createBiquadFilter
  , createMediaElementSource, createDelay, createAnalyser, createStereoPanner
  , destination, currentTime
  , sampleRate, decodeAudioData, decodeAudioDataAsync, createBufferSource
  ) where

import Prelude

import Audio.WebAudio.Types (AudioBuffer, AudioContext, AudioBufferSourceNode,
  BiquadFilterNode, DestinationNode, GainNode, MediaElementAudioSourceNode,
  DelayNode, OscillatorNode, AnalyserNode, StereoPannerNode, WebAudio)
import Audio.WebAudio.Utils (unsafeGetProp)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Aff (Aff)
import Control.Monad.Aff.Compat (EffFnAff, fromEffFnAff)
import Data.ArrayBuffer.Types (ArrayBuffer)

foreign import makeAudioContext
  :: ∀ eff. (Eff (wau :: WebAudio | eff) AudioContext)

foreign import createOscillator
  :: ∀ eff. AudioContext
  -> (Eff (wau :: WebAudio | eff) OscillatorNode)

foreign import createGain
  :: ∀ eff. AudioContext
  -> (Eff (wau :: WebAudio | eff) GainNode)

foreign import createMediaElementSource
  :: ∀ elt eff. AudioContext
  -> elt -- |^ a DOM element from which to construct the source node
  -> (Eff (wau :: WebAudio | eff) MediaElementAudioSourceNode)

foreign import createBiquadFilter
  :: ∀ eff. AudioContext
  -> (Eff (wau :: WebAudio | eff) BiquadFilterNode)

foreign import createAnalyser
  :: ∀ eff. AudioContext
  -> (Eff (wau :: WebAudio | eff) AnalyserNode)

foreign import createStereoPanner
    :: ∀ eff. AudioContext
    -> (Eff (wau :: WebAudio | eff) StereoPannerNode)

-- | createDelay also has an alternative constructor with a maximum delay
-- | note, if you don't set a max, it defaults to 1.0 and any attempt to set a greater value gives
-- | "paramDelay.delayTime.value 2 outside nominal range [0, 1]; value will be clamped."
foreign import createDelay
  :: ∀ eff. AudioContext
  -> (Eff (wau :: WebAudio | eff) DelayNode)

destination :: ∀ eff. AudioContext
            -> (Eff (wau :: WebAudio | eff) DestinationNode)

destination = unsafeGetProp "destination"

foreign import currentTime
  :: ∀ eff. AudioContext
  -> (Eff (wau :: WebAudio | eff) Number)

foreign import sampleRate
  :: ∀ eff. AudioContext
  -> (Eff (wau :: WebAudio | eff) Number)


foreign import decodeAudioData
  :: ∀ eff f.
     AudioContext
  -> ArrayBuffer
  -> (AudioBuffer -> Eff (wau :: WebAudio | eff) Unit) -- sucesss
  -> (String -> Eff (console :: CONSOLE | eff) Unit) -- failure
  -> (Eff (wau :: WebAudio | f) Unit)

foreign import decodeAudioDataAsyncImpl
  :: ∀ eff.
     AudioContext
  -> ArrayBuffer
  -> EffFnAff (wau :: WebAudio | eff) AudioBuffer

-- | decode the Audio Buffer asynchronously
decodeAudioDataAsync
  :: ∀ eff.
     AudioContext
  -> ArrayBuffer
  -> Aff (wau :: WebAudio | eff) AudioBuffer
decodeAudioDataAsync ctx =
  fromEffFnAff <<< (decodeAudioDataAsyncImpl ctx)

foreign import createBufferSource
  :: ∀ eff. AudioContext
  -> (Eff (wau :: WebAudio | eff) AudioBufferSourceNode)
