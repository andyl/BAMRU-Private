#= require ./member_fixture

describe "M3_Members", ->
  beforeEach ->
    window.inbox = []
    window.myid  = "24"
    @col = new M3_Members(m3_member_test_data)
  describe "basic object generation (no params)", ->
    it "generates an object", ->
      expect(@col).toBeDefined()
    it "has the right number of objects", ->
      expect(@col.length).toEqual(m3_member_test_data.length)
