#= require ./message_fixture

describe "Mobile2 Message Collection", ->
  beforeEach ->
    window.inbox = []
    window.myid  = "24"
    @col = new Messages(message_test_data)
  describe "basic object generation (no params)", ->
    it "generates an object", -> expect(@col).toBeDefined()
