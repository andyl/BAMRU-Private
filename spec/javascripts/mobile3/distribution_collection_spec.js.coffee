#= require ./distribution_fixture

describe "M3_Distributions Collection", ->
  beforeEach ->
    window.myID  = "2"
    @col = new M3_Distributions(m3_distribution_test_data)

  describe "basic collection generation (no params)", ->
    it "generates an object", ->
      expect(@col).toBeDefined()
    it "contains the right number of models", ->
      expect(@col.length).toEqual(4)

  describe "unreadCount", ->
    it "generates the correct unread count", ->
      expect(@col.unreadCount()).toEqual(1)

  describe "inbox", ->
    it "generates a list of models", ->
      expect(@col.inbox(2)).toBeDefined()

  describe "inbox attribute update", ->
    beforeEach ->
      @inbox2 = new M3_Distributions(@col.inbox(2))
    it "generates the correct number of inbox models", ->
      expect(@inbox2.length).toEqual(1)
    it "shows the right unreadCount", ->
      expect(@inbox2.unreadCount()).toEqual(1)
      expect(@col.unreadCount()).toEqual(1)
    it "handles attribute update", ->
      mod = @inbox2.models[0]
      mod.set({'read': true})
      expect(@inbox2.unreadCount()).toEqual(0)
      expect(@col.unreadCount()).toEqual(0)
