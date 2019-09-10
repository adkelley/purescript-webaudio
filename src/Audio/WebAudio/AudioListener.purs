module Audio.WebAudio.AudioListener
  ( positionX, positionY, positionZ
  , forwardX, forwardY, forwardZ
  , upX, upY, upZ
  , setPosition, setOrientation ) where

import Prelude (Unit)
import Audio.WebAudio.Types (AudioParam, AudioListener)
import Effect (Effect)

foreign import positionX :: AudioListener -> Effect AudioParam
foreign import positionY :: AudioListener -> Effect AudioParam
foreign import positionZ :: AudioListener -> Effect AudioParam
foreign import forwardX :: AudioListener -> Effect AudioParam
foreign import forwardY :: AudioListener -> Effect AudioParam
foreign import forwardZ :: AudioListener -> Effect AudioParam
foreign import upX :: AudioListener -> Effect AudioParam
foreign import upY :: AudioListener -> Effect AudioParam
foreign import upZ :: AudioListener -> Effect AudioParam

foreign import setPosition
  :: { x::Number, y::Number, z::Number }
  -> AudioListener
  -> Effect Unit
foreign import setOrientation
  :: { x::Number, y::Number, z::Number } -- forward
  -> { x::Number, y::Number, z::Number } -- up
  -> AudioListener
  -> Effect Unit
