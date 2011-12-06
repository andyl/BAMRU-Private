#= require ./chat_fixture
#= require chat2/collections/chats

describe "C2_Chats Collection", ->
  beforeEach ->
    @col = new C2_Chats(c2_chat_test_data)
    
  describe "basic object generation (no params)", ->
    it "generates an object", -> expect(@col).toBeDefined()
