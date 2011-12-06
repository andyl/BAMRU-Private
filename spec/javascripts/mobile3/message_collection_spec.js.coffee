#= require ./message_fixture

describe "M3_Message Collection", ->
  beforeEach ->
    window.inbox = []
    window.myid  = "24"
    @col = new M3_Messages(m3_message_test_data)
  describe "basic object generation (no params)", ->
    it "generates an object", -> expect(@col).toBeDefined()
