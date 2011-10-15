describe "Routes", ->
  describe "#blank", ->
    it "handles a valid string", ->
      expect(blank('asdf')).toBeFalsy()
    it "handes an empty string", ->
      expect(blank('')).toBeTruthy()
    it "handes an undefined string", ->
      expect(blank(undefined)).toBeTruthy()
