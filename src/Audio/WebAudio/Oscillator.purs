module Audio.WebAudio.Oscillator
  ( OscillatorType(..), readOscillatorType, frequency, detune
  , oscillatorType, setOscillatorType, startOscillator
  , stopOscillator) where

import Prelude
import Control.Monad.Eff (Eff)
import Audio.WebAudio.Types (AudioParam, OscillatorNode, WebAudio)
import Audio.WebAudio.Utils (unsafeGetProp, unsafeSetProp)

data OscillatorType = Sine | Square | Sawtooth | Triangle | Custom

instance oscillatorTypeShow :: Show OscillatorType where
    show Sine     = "sine"
    show Square   = "square"
    show Sawtooth = "sawtooth"
    show Triangle = "triangle"
    show Custom   = "custom"

readOscillatorType :: String -> OscillatorType
readOscillatorType "sine"     = Sine
readOscillatorType "square"   = Square
readOscillatorType "sawtooth" = Sawtooth
readOscillatorType "triangle" = Triangle
readOscillatorType "custom"   = Custom
readOscillatorType _          = Sine

frequency :: ∀ eff. OscillatorNode -> (Eff (wau :: WebAudio | eff) AudioParam)
frequency = unsafeGetProp "frequency"

detune :: ∀ eff. OscillatorNode -> (Eff (wau :: WebAudio | eff) AudioParam)
detune = unsafeGetProp "detune"

oscillatorType :: ∀ eff. OscillatorNode -> (Eff (wau :: WebAudio | eff) OscillatorType)
oscillatorType n = readOscillatorType <$> unsafeGetProp "type" n

setOscillatorType :: ∀ eff. OscillatorType -> OscillatorNode -> (Eff (wau :: WebAudio | eff) Unit)
setOscillatorType t n = unsafeSetProp "type" n $ show t

foreign import startOscillator :: ∀ eff. Number -> OscillatorNode -> (Eff (wau :: WebAudio | eff) Unit)
foreign import stopOscillator :: ∀ eff. Number -> OscillatorNode -> (Eff (wau :: WebAudio | eff) Unit)
