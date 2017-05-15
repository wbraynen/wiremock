# Introduction to mocking web services using WireMock

This is a simple example of how to use the WireMock tool (wiremock.org) as a standalone mock server. It demos the following features of WireMock:

* using JSON files to configure the mock server
* use of regex in pattern-matching endpoints
* delaying the response
* GETs and PUTs
* mocking stateful behavior (which makes sense when doing PUTs)
* using `curl` to verify that we have successfully mocked the endpoints

## How to install this demo

1. If you don't already have it, install the Java Runtime Environment (JRE).
1. Download the wiremock jar file. Link can be found here: http://wiremock.org/docs/running-standalone/
1. Then, if, for example, the jar is called ~/Downloads/wiremock-standalone-2.6.0.jar, do this:

```
$ clone https://github.com/wbraynen/wiremock.git # clone this demo
$ cd wiremock # go inside the wiremock directory you just cloned
$ mv ~/Downloads/wiremock-standalone-2.6.0.jar . # move the wiremock jar from Downloads into current directory
$ mv wiremock-standalone-2.6.0.jar wiremock.jar # rename wiremock jar to simply "wiremock.jar", so the "wiremock" launch shell script is version independent
$ chmod 744 wiremock.sh # make the shell script executable
$ ./wiremock.sh # launch the mock server; the shell script will run the wiremock.jar for you
```

## How to use this demo

### 1. first thing to try

GET /minions/blah
```
$ curl http://localhost:8080/minions/blah
```
"blah" is a minion id. Try any other id and it will work too :) Notice the delay?! If you don't, look inside the `1_GET_minions_anyResource_withDelay.json` file in the `mappings` folder and increase the delay from two to three seconds by changing the value of `fixedDelayMilliseconds` from 2000 to 3000.

### 2. second thing to try

GET /minions/cd3e
```
$ curl http://localhost:8080/minions/cd3e
```
"cd3e" Different mock json, so no delay this time!

### 3. third thing to try

PUT /minions/cd3e three times using the mock server as a state machine:
```
$ curl -X PUT http://localhost:8080/minions/cd3e
$ curl -X PUT http://localhost:8080/minions/cd3e
$ curl -X PUT http://localhost:8080/minions/cd3e
```
Each time you curl this same exact endpoint, the wiremock server will serve you a different json file.

To shut down the mock server, use ./wiremock -k

## What files got served

The JSON files that the wiremock server serves from the mappings directory when you follow the steps above:

1. GET /minions/blah: `1_GET_minions_anyResource_withDelay.json`
1. GET /minions/cd3e: `2_GET_minions_cd3e.json`
1. PUT /minions/cd3e: `3a_PUT_minions_cd3e.json` the first time, `3b_PUT_minions_cd3e.json` the second time, `3c_PUT_minions_cd3e.json` the third time.

## FAQ

Q: Should the mock json files say "mental_state" or "mentalState"?

A: "JSON" stands for "JavaScript Object Notation", so that might be a reason for jsons to follow JavaScript conventions, which is camelCase.  However, snake_case seems more readable to me in this particular case, so I stuck with "mental_state" instead of "mentalState".  I think I remember seeing readability studies on both sides of the case fence.  [Binkley et al. (2009)](http://www.cs.loyola.edu/~binkley/papers/icpc09-clouds.pdf), for example, report empirical findings in favor of camel case.  [Sharif and Maletic (2010)](http://www.cs.kent.edu/~jmaletic/papers/ICPC2010-CamelCaseUnderScoreClouds.pdf), on the other hand, in their attempt to reproduce an earlier study, report that snake case was quicker to read.  (Also, if your json-parsing-deserialization library expects camelCase, then that might be a good reason to use camel case.)  Because my goal in this tutorial is readability, I went with snake_case.  And if you know of good literature review on this, let me know!


Q: Anything I should know about build settings in Xcode related to using WireMock in automated UI tests?

A: Yes, possibly.  Here is a related post: http://allegro.tech/2016/10/self-contained-UI-tests-for-ios-applications.html


Q: Are there other tools aside from WireMock with which to mock web services and REST APIs?

A: Yes, lots.  For example: apimocker.js.  Swagger also has a mock server.
