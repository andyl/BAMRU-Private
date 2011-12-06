#= require ./message_fixture
#= require ./member_fixture
#= require ./distribution_fixture

describe "M3_Message", ->
  beforeEach ->
    @msg0 = new M3_Message(m3_message_test_data[0])
    @msg1 = new M3_Message(m3_message_test_data[1])
    @msg2 = new M3_Message(m3_message_test_data[2])
    window.unitLog = new M3_Distributions(m3_distribution_test_data)
    window.unitRoster = new M3_Members(m3_member_test_data)

  describe "basic object generation (no params)", ->
    it "generates an object",        -> expect(@msg0).toBeDefined()
    it "shows a valid id attribute", -> expect(@msg0.get('id')).toEqual(1)
    
  describe "basic object generation (with distribution)", ->
    it "generates an object",        -> expect(@msg1).toBeDefined()
    it "shows a valid id attribute", -> expect(@msg1.get('id')).toBeDefined()

  describe "basic object generation (with rsvp)", ->
    it "generates an object",        -> expect(@msg2).toBeDefined()
    it "shows a valid id attribute", -> expect(@msg2.get('id')).toBeDefined()

  describe "author", ->
    beforeEach ->
      @msg0.set({'roster': unitRoster})
    it "has an author", -> expect(@msg0.get('author_id')).toBeDefined()
    it "supports an associated roster", ->
      expect(@msg0.get('roster')).toBeDefined()
    it "retrieves an author", ->
      expect(@msg0.author()).toBeDefined()
    it "renders the author shortName", ->
      expect(@msg0.author().shortName()).toBeDefined()

  describe "distribution", ->
    describe "with empty distribution list", ->
      beforeEach ->
        @msg0.set({'distributions' : new M3_Distributions()})
      it "has a distribution list", ->
        expect(@msg0.has('distributions')).toBeTruthy()
      it "distribution list has the right number of elements", ->
        expect(@msg0.get('distributions').length).toEqual 0

    describe "with non-empty distribution list", ->
      beforeEach ->
        @msg0.set({'unitDistributions' : unitLog})
      it "is the same as the unitLog", ->
        expect(@msg0.unitDistributions()).toEqual unitLog
      it "has the right number of unitDistribution elements", ->
        expect(@msg0.unitDistributions().length).toEqual 4
      it "has the right number of distribution elements", ->
        expect(@msg0.distributions().length).toEqual 1
      it "works when called twice in a row", ->
        expect(@msg0.distributions().length).toEqual 1
        expect(@msg0.distributions().length).toEqual 1

  describe "sentCount", ->
    beforeEach ->
      @msg0.set({'unitDistributions': unitLog})
    it "has the correct sentCount", ->
      expect(@msg0.sentCount()).toEqual 1

  describe "readCount", ->
    beforeEach ->
      @msg0.set({'unitDistributions': unitLog})
    it "has the correct count", ->
      expect(@msg0.readCount()).toEqual 1

