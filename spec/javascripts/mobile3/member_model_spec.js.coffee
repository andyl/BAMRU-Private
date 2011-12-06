#= require ./member_fixture

# ----- Model Specs -----

describe "M3_Member", ->
  beforeEach ->
    @col_path = "/collection"
    @mem0 = new M3_Member(m3_member_test_data[0])
    col  = { url: @col_path }
    @mem0.collection = col

  describe "basic object generation", ->
    it "generates an object", ->
      expect(@mem0).toBeDefined()
    it "generates a new object", ->
      expect(@mem0.isNew()).toBeFalsy()
    it "updates the input name", ->
      local_name     = "New Name"
      @mem0.set({"full_name": local_name})
      (expect @mem0.get('full_name')).toEqual(local_name)

  describe "url", ->
    it 'has a default url', ->
      expect(@mem0.url()).toBeDefined()
      expect(@mem0.url()).toEqual "#{@col_path}/1"
    describe "when id is set", ->
      it "returns the collection URL and ID", ->
        @mem0.id = 1
        expect(@mem0.url()).toEqual @col_path + '/1'
  describe "shortName", ->
    it "returns the shortName", ->
      expect(@mem0.shortName()).toEqual "A. Leak"

  describe "Member Predicates", ->
    beforeEach ->
      @mem1 = new M3_Member(m3_member_test_data[1])
      @mem2 = new M3_Member(m3_member_test_data[2])
    describe "#hasPhone", ->
      it 'returns false when phone does not exist', ->
        expect(@mem0.hasPhone()).toEqual false
      it 'returns true when phone exists', ->
        expect(@mem1.hasPhone()).toEqual true
      it 'returns false when phone is empty', ->
        expect(@mem2.hasPhone()).toEqual false
    describe "#hasPhoto", ->
      it 'returns false when photo does not exist', ->
        expect(@mem0.hasPhoto()).toEqual true
      it 'returns true when photo exists', ->
        expect(@mem1.hasPhoto()).toEqual true


# ----- Collection Specs -----

describe "M3_Members", ->
  beforeEach ->
    @obj = new M3_Members(m3_member_test_data)

  describe "basic object generation", ->
    it "generates an object", ->
      expect(@obj).toBeDefined()
    it "has a length", ->
      expect(@obj.models.length).toEqual(3)

describe "M3 Server Fetch", ->
  beforeEach ->
    @url    = "/api/mobile3/members"
    @server = sinon.fakeServer.create()
    @server.respondWith "GET", @url, [
      200
      "Content-Type": "application/json"
      JSON.stringify(m3_member_test_data)
    ]
    @members = new M3_Members

  afterEach ->
    @server.restore()

  it "should make a correct request", ->
    @members.fetch()
    expect(@server.requests.length).toEqual(1)
    expect(@server.requests[0].method).toEqual("GET")
    expect(@server.requests[0].url).toEqual(@url)