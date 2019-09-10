module Audio.WebAudio.PannerNode
  ( DistanceModelType(..), distanceModel, setDistanceModel
  , refDistance, setRefDistance
  , maxDistance, setMaxDistance
  , rolloffFactor, setRolloffFactor
  , PanningModelType(..), panningModel, setPanningModel
  , coneInnerAngle, setConeInnerAngle
  , coneOuterAngle, setConeOuterAngle
  , coneOuterGain, setConeOuterGain
  , positionX, positionY, positionZ
  , orientationX, orientationY, orientationZ
  , setPosition, setOrientation ) where

import Audio.WebAudio.Types (AudioParam, PannerNode)
import Audio.WebAudio.Utils (unsafeGetProp, unsafeSetProp)
import Effect (Effect)
import Prelude

data DistanceModelType = Linear
                       | Inverse
                       | Exponential

instance distanceModelTypeShow :: Show DistanceModelType where
  show Linear      = "linear"
  show Inverse     = "inverse"
  show Exponential = "exponential"

derive instance eqDistanceModelType :: Eq DistanceModelType
derive instance ordDistanceModelType :: Ord DistanceModelType

distanceModel :: PannerNode -> Effect DistanceModelType
distanceModel n = unsafeGetProp "distanceModel" n <#> case _ of
  "linear"      -> Linear
  "inverse"     -> Inverse
  "exponential" -> Exponential
  _             -> Inverse

setDistanceModel :: DistanceModelType -> PannerNode -> Effect Unit
setDistanceModel t n = unsafeSetProp "distanceModel" n (show t)

refDistance :: PannerNode -> Effect Number
refDistance n = unsafeGetProp "refDistance" n

setRefDistance :: Number -> PannerNode -> Effect Unit
setRefDistance v n = unsafeSetProp "refDistance" n v

maxDistance :: PannerNode -> Effect Number
maxDistance n = unsafeGetProp "maxDistance" n

setMaxDistance :: Number -> PannerNode -> Effect Unit
setMaxDistance v n = unsafeSetProp "maxDistance" n v

rolloffFactor :: PannerNode -> Effect Number
rolloffFactor n = unsafeGetProp "rolloffFactor" n

setRolloffFactor :: Number -> PannerNode -> Effect Unit
setRolloffFactor v n = unsafeSetProp "rolloffFactor" n v

data PanningModelType = EqualPower
                      | HRTF

instance showPanningModelType :: Show PanningModelType where
  show EqualPower = "equalpower"
  show HRTF       = "HRTF"

derive instance eqPanningModelType :: Eq PanningModelType
derive instance ordPanningModelType :: Ord PanningModelType

panningModel :: PannerNode -> Effect PanningModelType
panningModel n = unsafeGetProp "panningModel" n <#> case _ of
  "equalpower" -> EqualPower
  "HRTF"       -> HRTF
  _            -> EqualPower

setPanningModel :: PanningModelType -> PannerNode -> Effect Unit
setPanningModel t n = unsafeSetProp "panningModel" n (show t)

coneInnerAngle :: PannerNode -> Effect Number
coneInnerAngle n = unsafeGetProp "coneInnerAngle" n

setConeInnerAngle :: Number -> PannerNode -> Effect Unit
setConeInnerAngle v n = unsafeSetProp "coneInnerAngle" n v

coneOuterAngle :: PannerNode -> Effect Number
coneOuterAngle n = unsafeGetProp "coneOuterAngle" n

setConeOuterAngle :: Number -> PannerNode -> Effect Unit
setConeOuterAngle v n = unsafeSetProp "coneOuterAngle" n v

coneOuterGain :: PannerNode -> Effect Number
coneOuterGain n = unsafeGetProp "coneOuterGain" n

setConeOuterGain :: Number -> PannerNode -> Effect Unit
setConeOuterGain v n = unsafeSetProp "coneOuterGain" n v

foreign import positionX :: PannerNode -> Effect AudioParam
foreign import positionY :: PannerNode -> Effect AudioParam
foreign import positionZ :: PannerNode -> Effect AudioParam
foreign import orientationX :: PannerNode -> Effect AudioParam
foreign import orientationY :: PannerNode -> Effect AudioParam
foreign import orientationZ :: PannerNode -> Effect AudioParam

foreign import setPosition
  :: { x::Number, y::Number, z::Number } -> PannerNode -> Effect Unit

foreign import setOrientation
  :: { x::Number, y::Number, z::Number } -> PannerNode -> Effect Unit
