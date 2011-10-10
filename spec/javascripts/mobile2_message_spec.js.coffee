describe "Mobile2 Message", ->
  beforeEach ->
    @obj = new Message
  describe "basic object generation", ->
    it "generates an object", ->
      expect(@obj).toBeDefined()
    it "updates the input name", ->
      local_name     = "New Name"
      @obj.full_name = local_name
      (expect @obj.full_name).toEqual(local_name)