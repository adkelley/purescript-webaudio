"use strict";

// module Audio.WebAudio.ListenerNode

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
exports.forwardX = function(listener) {
  return function() {
    return listener.forwardX;
  };
};
exports.forwardY = function(listener) {
  return function() {
    return listener.forwardY;
  };
};
exports.forwardZ = function(listener) {
  return function() {
    return listener.forwardZ;
  };
};
exports.upX = function(listener) {
  return function() {
    return listener.upX;
  };
};
exports.upY = function(listener) {
  return function() {
    return listener.upY;
  };
};
exports.upZ = function(listener) {
  return function() {
    return listener.upZ;
  };
};

exports.setPosition = function (pos) {
  return function(listener) {
    if (listener.positionX) {
      return function() {
        listener.positionX.value = pos.x;
        listener.positionY.value = pos.y;
        listener.positionZ.value = pos.z;
      };
    } else {
      return function() {
        listener.setPosition(pos.x, pos.y, pos.z);
      };
    }
  };
};

exports.setOrientation = function(fw) {
  return function(up) {
    return function(listener) {
      if (listener.forwardX) {
        return function() {
          listener.forwardX.value = fw.x;
          listener.forwardY.value = fw.y;
          listener.forwardZ.value = fw.z;
          listener.upX.value = up.x;
          listener.upY.value = up.y;
          listener.upZ.value = up.z;
        };
      } else {
        return function() {
          listener.setOrientation(fw.x, fw.y, fw.z, up.x, up.y, up.z);
        };
      }
    };
  };
};

