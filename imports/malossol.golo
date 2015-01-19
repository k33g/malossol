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
  function toBeLessThan = |this, expectedValue| {
    require(this: actualValue() < expectedValue, this: actualValue() + " isn't less than " + expectedValue)
    println(" OK: " + this: actualValue() + " is less than " + expectedValue)
    return this
  }
  function notToBeLessThan = |this, expectedValue| {
    require(not this: actualValue() < expectedValue, this: actualValue() + " is less than " + expectedValue)
    println(" OK: " + this: actualValue() + " is not less than " + expectedValue)
    return this
  }
  function toBeInteger = |this| {
    require(this: actualValue() oftype Integer.class, this: actualValue() + " is not an Integer")
    println(" OK: " + this: actualValue() + " is an Integer")
    return this
  }
}

augmentation stringMatchers = {
  function toContain = |this, expectedValue| {
    require(
      this: actualValue(): contains(expectedValue),
      this: actualValue() + " doesn't contain " + expectedValue
    )
    println(" OK: " + this: actualValue() + " contains " + expectedValue)
    return this
  }
  function toStartWith = |this, expectedValue| {
    require(
      this: actualValue(): startsWith(expectedValue),
      this: actualValue() + " doesn't start with " + expectedValue
    )
    println(" OK: " + this: actualValue() + " starts with " + expectedValue)
    return this
  }
}

augment matchers with stringMatchers


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

function getHttp = |url, contenType| {
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


# Tools
----
  let t = timer(): start(|self| {
    Thread.sleep(500_L)
  }): stop(|self|{
    println(self: duration() + " ms")
  })
----
struct timer = {
  begin, end, duration
}
augment timer {
  function start = |this| {
    this: begin(java.lang.System.currentTimeMillis())
    return this
  }
  function start = |this, callback| {
    this: begin(java.lang.System.currentTimeMillis())
    callback(this)
    return this
  }
  function stop = |this| {
    this: end(java.lang.System.currentTimeMillis())
    this: duration(this: end() - this: begin())
    return this
  }
  function stop = |this, callback| {
    this: end(java.lang.System.currentTimeMillis())
    this: duration(this: end() - this: begin())
    callback(this)
    return this
  }
}






