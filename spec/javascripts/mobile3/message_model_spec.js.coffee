#= require ./message_fixture

describe "M3_Message", ->
  beforeEach ->
    @msg0 = new M3_Message(message_test_data[0])
    @msg1 = new M3_Message(message_test_data[1])
    @msg2 = new M3_Message(message_test_data[2])
    window.inbox = new M3_Distributions()
  describe "basic object generation (no params)", ->
    it "generates an object",        -> expect(@msg0).toBeDefined()
    it "shows a valid id attribute", -> expect(@msg0.get('id')).toEqual(24)
    
  describe "basic object generation (with distribution)", ->
    it "generates an object",        -> expect(@msg1).toBeDefined()
    it "shows a valid id attribute", -> expect(@msg1.get('id')).toBeDefined()

  describe "basic object generation (with rsvp)", ->
    it "generates an object",        -> expect(@msg2).toBeDefined()
    it "shows a valid id attribute", -> expect(@msg2.get('id')).toBeDefined()

  describe "distributions", ->
    it "should have a distribution", ->
      expect(@msg1.get('distributions')).toBeDefined()
    it "should have the right length (short)", ->
      expect(@msg1.get('distributions').length).toEqual(1)
    it "should have the right length (long)", ->
      expect(@msg2.get('distributions').length).toEqual(2)

  describe "distribution functions", ->
    it "should give the right readCount", ->
      expect(@msg2.readCount()).toEqual(1)
    it "should give the right unreadCount", ->
      expect(@msg2.unreadCount()).toEqual(1)
    it "should give the right rsvpYesCount", ->
      expect(@msg2.rsvpYesCount()).toEqual(0)
    it "should give the right rsvpNoCount", ->
      expect(@msg2.rsvpNoCount()).toEqual(1)

  describe "inbox", ->
    it "should be defined", ->
      expect(inbox).toBeDefined()
    it "should have the right length", ->
      expect(inbox.models.length).toEqual(0)