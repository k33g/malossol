module malossol


import gololang.Async
import gololang.concurrent.workers.WorkerEnvironment

----
 matchers structure
----
struct matchers = {
  actualValue
}

augment matchers {
  function toEqual = |this, expectedValue| {
    require(this: actualValue(): equals(expectedValue), this: actualValue() + " isn't equal to " + expectedValue)
    println(" OK: " + this: actualValue() + " is equal to " + expectedValue)
    return this
  }
  function notToEqual = |this, expectedValue| {
    require(not this: actualValue(): equals(expectedValue), this: actualValue() + " is equal to " + expectedValue)
    println(" OK: " + this: actualValue() + " is not equal to " + expectedValue)
    return this
  }
  function toBeInteger = |this| {
    require(this: actualValue() oftype Integer.class, this: actualValue() + " is not an Integer")
    println(" OK: " + this: actualValue() + " is an Integer")
    return this
  }
}

# suites : describe 

function describe = |whatIsBeingTested, suiteImplementation| { # suiteImplementation is a closure (lambda?)
  println("-- SUITE ----------------------------------------")
  println(" " + whatIsBeingTested)
  println("-------------------------------------------------")

  suiteImplementation()
}

# specs (it)

function it = |titleOfTheSpec, specFunction| {
  println(" " + "Spec: " + titleOfTheSpec)
  specFunction()  
}

function expect = |value|-> matchers(): actualValue(value)


# http tools
function JSON = -> "application/json;charset=UTF-8"
function HTML = -> "text/html;charset=UTF-8"

struct response = {
  code,
  message,
  text
}

local function getHttp = |url, contenType| {
  try {
    let obj = java.net.URL(url) # URL obj
    let con = obj: openConnection() # HttpURLConnection
    con: setRequestMethod("GET")
    con: setRequestProperty("Content-Type", contenType)
    #add request header
    con: setRequestProperty("User-Agent", "Mozilla/5.0")

    let responseCode = con: getResponseCode() # int responseCode
    let responseMessage = con: getResponseMessage() # String responseMessage

    let responseText = java.util.Scanner(
      con: getInputStream(),
      "UTF-8"
    ): useDelimiter("\\A"): next() # String responseText

    return response(responseCode, responseMessage, responseText)
  } catch (err) {
    throw err
  }
}



# asynchronous tools


----
  Promise helper: it's easier to make asynchronous work
  Augmentation of gololang.concurrent.async.Promise
----
augment gololang.concurrent.async.Promise {
----
 `env` is a worker environment
----
  function initializeWithWorker = |this, env, closure| {
    env: spawn(|message| {
      this: initialize(closure)
    }): send("")
    return this: future()
  }
----
 ...
----
  function initializeWithThread = |this, closure| {
    Thread({
      this: initialize(closure)
    }): start()
    return this: future()
  }
----
 ...
----
  function initializeWithJoinedThread = |this, closure| {
    let t = Thread({
      this: initialize(closure)
    })
    t: start()
    t: join()
    return this: future()
  }
}

# promise tools
function getAndWaitHttpRequest = |url, contentType| {
  return promise(): initializeWithJoinedThread(|resolve, reject| {
    try {
      let r = getHttp(url, contentType)
      resolve(r)
    } catch (e) {
      reject(e)
    }
  })
}






