#= require ./message_fixture

describe "M3_Message", ->
  beforeEach ->
    @dst0 = new M3_Message(message_test_data[0])
    @dst1 = new M3_Message(message_test_data[1])
    @dst2 = new M3_Message(message_test_data[2])
    window.inbox = new M3_Distributions()
  describe "basic object generation (no params)", ->
    it "generates an object",        -> expect(@dst0).toBeDefined()
    it "shows a valid id attribute", -> expect(@dst0.get('id')).toEqual(24)
    
  describe "basic object generation (with distribution)", ->
    it "generates an object",        -> expect(@dst1).toBeDefined()
    it "shows a valid id attribute", -> expect(@dst1.get('id')).toBeDefined()

  describe "basic object generation (with rsvp)", ->
    it "generates an object",        -> expect(@dst2).toBeDefined()
    it "shows a valid id attribute", -> expect(@dst2.get('id')).toBeDefined()

