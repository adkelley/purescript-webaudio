module Audio.WebAudio.AudioContext
  ( makeAudioContext, createOscillator, createGain
  , createMediaElementSource, destination, currentTime
  , sampleRate, decodeAudioData, createBufferSource
  , connect, disconnect
  ) where

import Prelude

import Audio.WebAudio.Types (class AudioNode, AudioBuffer, AudioContext, AudioBufferSourceNode, DestinationNode, GainNode, MediaElementAudioSourceNode, OscillatorNode, AUDIO)
import Audio.WebAudio.Utils (unsafeGetProp)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Data.ArrayBuffer.Types (ArrayBuffer)


foreign import makeAudioContext
  :: ∀ eff. (Eff (audio :: AUDIO | eff) AudioContext)

foreign import createOscillator
  :: ∀ eff. AudioContext
  -> (Eff (audio :: AUDIO | eff) OscillatorNode)

foreign import createGain
  :: ∀ eff. AudioContext
  -> (Eff (audio :: AUDIO | eff) GainNode)

foreign import createMediaElementSource
  :: ∀ elt eff. AudioContext
  -> elt -- |^ a DOM element from which to construct the source node
  -> (Eff (audio :: AUDIO | eff) MediaElementAudioSourceNode)

destination :: ∀ eff. AudioContext
            -> (Eff (audio :: AUDIO | eff) DestinationNode)

destination = unsafeGetProp "destination"

foreign import currentTime
  :: ∀ eff. AudioContext
  -> (Eff (audio :: AUDIO | eff) Number)

foreign import sampleRate
  :: ∀ eff. AudioContext
  -> (Eff (audio :: AUDIO | eff) Number)


foreign import decodeAudioData
  :: ∀ eff f.
     AudioContext
  -> ArrayBuffer
  -> (AudioBuffer -> Eff (audio :: AUDIO | eff) Unit) -- sucesss
  -> (String -> Eff (console :: CONSOLE | eff) Unit) -- failure
  -> (Eff (audio :: AUDIO | f) Unit)

foreign import createBufferSource
  :: ∀ eff. AudioContext
  -> (Eff (audio :: AUDIO | eff) AudioBufferSourceNode)

-- this is really a method on an AudioNode.

-- foreign import connect
foreign import connect  :: ∀ m n eff. AudioNode m => AudioNode n => m
  -> n
  -> (Eff (audio :: AUDIO | eff) Unit)

foreign import disconnect  :: ∀ m n eff. AudioNode m => AudioNode n => m
  -> n
  -> (Eff (audio :: AUDIO | eff) Unit)
