"use strict";

// module Audio.WebAudio.PannerNode

exports.positionX = function(listener) {
  return function() {
    return listener.positionX;
  };
};
exports.positionY = function(listener) {
  return function() {
    return listener.positionY;
  };
};
exports.positionZ = function(listener) {
  return function() {
    return listener.positionZ;
  };
};
exports.orientationX = function(listener) {
  return function() {
    return listener.orientationX;
  };
};
exports.orientationY = function(listener) {
  return function() {
    return listener.orientationY;
  };
};
exports.orientationZ = function(listener) {
  return function() {
    return listener.orientationZ;
  };
};

exports.setPosition = function (pos) {
  return function(panner) {
    if (panner.positionX) {
      return function() {
        panner.positionX.value = pos.x;
        panner.positionY.value = pos.y;
        panner.positionZ.value = pos.z;
      };
    } else {
      return function() {
        panner.setPosition(pos.x, pos.y, pos.z);
      };
    }
  };
};

exports.setOrientation = function (orientation) {
  return function(panner) {
    if (panner.orientationX) {
      return function() {
        panner.orientationX.value = orientation.x;
        panner.orientationY.value = orientation.y;
        panner.orientationZ.value = orientation.z;
      };
    } else {
      return function() {
        panner.setOrientation(orientation.x, orientation.y, orientation.z);
      };
    }
  };
};
