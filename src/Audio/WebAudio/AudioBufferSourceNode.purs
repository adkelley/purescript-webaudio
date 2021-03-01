module Audio.WebAudio.AudioBufferSourceNode
  ( StartOptions, defaultStartOptions, setBuffer, startBufferSource, stopBufferSource
  , loop, setLoop, loopStart, setLoopStart, loopEnd, setLoopEnd
  , detune, playbackRate, onended ) where

-- | Audio Buffer Source Node.  This is an audio source consisting of in-memory
-- | audio data, stored in an AudioBuffer.
-- | See https://developer.mozilla.org/en-US/docs/Web/API/AudioBufferSourceNode.

import Prelude

import Audio.WebAudio.Types (AudioBuffer, AudioBufferSourceNode, AudioParam, Seconds)
import Audio.WebAudio.Utils (unsafeGetProp, unsafeSetProp)
import Effect (Effect)
import Data.Maybe (Maybe(..))
import Web.Event.Event (Event)

-- | A record of options to the function startBufferSource
-- | See Webaudio API AudioBufferSourcenode.start for more information
-- | https://developer.mozilla.org/en-US/docs/Web/API/AudioBufferSourceNode/start
type StartOptions =
  { when ::     Maybe Seconds
  , offset ::   Maybe Seconds
  , duration :: Maybe Seconds
  }

foreign import startBufferSourceFn4
  :: Seconds
   → Seconds
   → Seconds
   → AudioBufferSourceNode
   → Effect Unit

foreign import startBufferSourceFn3
  :: Seconds
   → Seconds
   → AudioBufferSourceNode
   → Effect Unit

foreign import startBufferSourceFn2
  :: Seconds
   → AudioBufferSourceNode
   → Effect Unit

foreign import startBufferSourceFn1
  :: AudioBufferSourceNode
   → Effect Unit


-- | A convenience function specifying the default parameters
-- | for the function startBuffersource
defaultStartOptions :: StartOptions
defaultStartOptions = { when: Nothing, offset: Nothing, duration: Nothing }

-- | Start playing the AudioBuffer. Match on the
-- | record `StartOptions` to determine what options
-- | have been specified by the calling function.
startBufferSource :: StartOptions → AudioBufferSourceNode → Effect Unit
startBufferSource { when: Nothing, offset: Nothing, duration: Nothing } start =
  startBufferSourceFn1 start -- |^ this is the default
startBufferSource { when: Just when, offset: Just offset, duration: Just duration } start =
  startBufferSourceFn4 when offset duration start
startBufferSource { when: Just when, offset: Just offset, duration: Nothing } start =
  startBufferSourceFn3 when offset start
startBufferSource { when: Just when, offset: Nothing, duration: Nothing } start =
  startBufferSourceFn2 when start
startBufferSource { when: _, offset: _, duration: _ } start =
  startBufferSourceFn1 start  -- |^ this should probably be an error in the future

-- | Prime the node with its AudioBuffer.
foreign import setBuffer
  :: AudioBuffer
  -> AudioBufferSourceNode
  -> Effect Unit

-- | Stop playing the AudioBuffer.
foreign import stopBufferSource
  :: Seconds
  -> AudioBufferSourceNode
  -> Effect Unit

-- | Indicate that the AudioBuffer should be replayed from the start once its
-- | end has been reached.
loop :: AudioBufferSourceNode -> Effect Boolean
loop = unsafeGetProp "loop"

setLoop :: Boolean -> AudioBufferSourceNode -> Effect Unit
setLoop l n = unsafeSetProp "loop" n l

-- | The time, in seconds, at which playback of the AudioBuffer must begin when
-- | loop is true (default 0).
loopStart :: AudioBufferSourceNode -> Effect Seconds
loopStart = unsafeGetProp "loopStart"

setLoopStart :: Seconds -> AudioBufferSourceNode -> Effect Unit
setLoopStart l n = unsafeSetProp "loopStart" n l

-- | The time, in seconds, at which playback of the AudioBuffer must end when
-- | loop is true (default 0).
loopEnd :: AudioBufferSourceNode -> Effect Seconds
loopEnd = unsafeGetProp "loopEnd"

setLoopEnd :: Seconds -> AudioBufferSourceNode -> Effect Unit
setLoopEnd l n = unsafeSetProp "loopEnd" n l

foreign import detune :: AudioBufferSourceNode -> Effect AudioParam
foreign import playbackRate :: AudioBufferSourceNode -> Effect AudioParam
foreign import onended
  :: AudioBufferSourceNode
  -> (Event -> Effect Unit) -- called by the browser when the ended event occurs
  -> Effect Unit
