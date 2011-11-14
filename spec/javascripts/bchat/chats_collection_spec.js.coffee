#= require ./chat_fixture
#= require bchat/collections/chats

describe "BC1_Chats Collection", ->
  beforeEach ->
    @col = new BC1_Chats(bchat_test_data)
    
  describe "basic object generation (no params)", ->
    it "generates an object", -> expect(@col).toBeDefined()
