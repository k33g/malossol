Malossol
========

Golo BDD dsl

You can test Golo code, but Java too!

```coffeescript
  describe("Search something ...", {
    it("code response is 200", {
      
      getAndWaitHttpRequest("http://www.google.com", HTML())
        : onSet(|response| {
            expect(response: code()): toEqual(200): toBeInteger()
          })
    })
  })

  describe("Test some numbers", {
    it("4/2 = 2", {
      expect(2): toBeHalf(4): toBeInteger()
    })
  })

  describe("Testing Java: Elmira", {

    let Elmira = Toon("Elmira")

    it("is Elmira", {
      expect(Elmira: getName()): toEqual("Elmira")
    })

    it("loves Toons", {
      
      let Buster = Toon(): name("Buster Bunny")
      
      expect(Elmira: hug(Buster)): toEqual("I <3 " + Buster: name())

    })

  })
```

