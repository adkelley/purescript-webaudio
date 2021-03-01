# purescript-webaudio

[![Latest release](http://img.shields.io/github/release/adkelley/purescript-webaudio.svg)](https://github.com/adkelley/purescript-webaudio/releases)
[![Build status](https://travis-ci.org/adkelley/purescript-webaudio.svg?branch=master)](https://travis-ci.org/adkelley/purescript-webaudio)

This library provides PureScript wrappers for the HTML5 [Web Audio
API](https://webaudio.github.io/web-audio-api/)

## Installation

$ spago build OR  bower install followed by pulp build
  
## Documentation
Module documentation is [published on Pursuit](https://pursuit.purescript.org/packages/purescript-webaudio)
  
## Examples  

To build the examples perform the following scripts in order:
1. `npm run spago:build:example:xx` where xx is the example (squareWave, gain, decode, decodeAsync)

To run the examples in your browser, perform the following scripts in order:
1. `npm run exec:example:xx` where xx is the example (squareWave, gain, decode, decodeAsync)

Note: The resolutions in the bower.json file (e.g., "purescript-typelevel") are required to compile and run "squareWave". These versions don't appear to conflict
with the purescript-webaudio libary.

## Tests

To build the test suite
1. `npm run spago:build:test:props`

To run the test suite
1. `npm run exec:test:props` and inspect the output log

