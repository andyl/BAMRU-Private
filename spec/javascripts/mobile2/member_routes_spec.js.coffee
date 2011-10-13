describe "Routes", ->
  describe "#parseUrl", ->
    it "handles an empty string", ->
      expect(parseUrl("")).toEqual(["",""])
    it "handles just a hash", ->
      expect(parseUrl("#asdf")).toEqual(["#asdf",""])
    it "handles a hash and an id", ->
      expect(parseUrl("#asdf?id=33")).toEqual(["#asdf","33"])
    it "handles a hash and an id, swapped positions", ->
      expect(parseUrl("?id=33#asdf")).toEqual(["#asdf","33"])
    it "handles an extra query param", ->
      expect(parseUrl("#asdf?id=33&rand=342")).toEqual(["#asdf","33"])