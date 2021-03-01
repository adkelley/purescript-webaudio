module Audio.WebAudio.Utils
  ( createUint8Buffer, createFloat32Buffer, unsafeGetProp, unsafeSetProp) where

import Prelude
import Effect (Effect)
import Data.ArrayBuffer.Types (ByteLength, Uint8Array, Float32Array)
import Data.ArrayBuffer.Typed (empty)

-- | set a named property an audio node
foreign import unsafeSetProp :: forall obj val. String -> obj -> val -> Effect Unit

-- | get a named property from an audio node
foreign import unsafeGetProp :: forall obj val. String -> obj -> Effect val

-- | create an unsigned 8-bit integer buffer for use with an analyser node
createUint8Buffer :: ByteLength -> Effect Uint8Array
createUint8Buffer len =
  empty len

-- | create a Float 32 buffer for use with an analyser node
createFloat32Buffer :: ByteLength -> Effect Float32Array
createFloat32Buffer len =
  empty len
