#= require ./chat_fixture

describe "C2_Chat", ->
  beforeEach ->
    @chat0 = new C2_Chat(c2_message_test_data[0])
    @chat1 = new C2_Chat(c2_message_test_data[1])
    @chat2 = new C2_Chat(c2_message_test_data[2])

  describe "basic object generation (no params)", ->
    it "generates an object",        -> expect(@chat0).toBeDefined()
    it "shows a valid id attribute", -> expect(@chat0.get('id')).toEqual(1)
    
  describe "basic object generation (with chat)", ->
    it "generates an object",        -> expect(@chat1).toBeDefined()
    it "shows a valid id attribute", -> expect(@chat1.get('id')).toBeDefined()

  describe "basic object generation (with rsvp)", ->
    it "generates an object",        -> expect(@chat2).toBeDefined()
    it "shows a valid id attribute", -> expect(@chat2.get('id')).toBeDefined()
