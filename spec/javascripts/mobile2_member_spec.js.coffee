member_test_data = [
    first_name: "Andy"
    last_name:  "Leak"
  ,
    first_name: "John"
    last_name:  "Chang"
  ]

# ----- Model Specs -----

describe "Mobile2 Member", ->
  beforeEach ->
    @col_path = "/collection"
    @obj = new Member(member_test_data[0])
    col  = { url: @col_path }
    @obj.collection = col
  describe "basic object generation", ->
    it "generates an object", ->
      expect(@obj).toBeDefined()
    it "generates a new object", ->
      expect(@obj.isNew()).toBeTruthy()
    it "updates the input name", ->
      local_name     = "New Name"
      @obj.set({"full_name": local_name})
      (expect @obj.get('full_name')).toEqual(local_name)
  describe "url", ->
    it 'has a default url', ->
      expect(@obj.url()).toBeDefined()
      expect(@obj.url()).toEqual @col_path
    describe "when no id is set", ->
      it "returns the collection URL", ->
        expect(@obj.url()).toEqual @col_path
    describe "when id is set", ->
      it "returns the collection URL and ID", ->
        @obj.id = 1
        expect(@obj.url()).toEqual @col_path + '/1'

# ----- Collection Specs -----

describe "Mobile2 Members", ->
  beforeEach ->
    @obj = new Members(member_test_data)
  describe "basic object generation", ->
    it "generates an object", ->
      expect(@obj).toBeDefined()
    it "has a length", ->
      expect(@obj.models.length).toEqual(2)

describe "Mobile2 Server Fetch", ->
  beforeEach ->
    @url    = "/mobile2/members"
    @server = sinon.fakeServer.create()
    @server.respondWith "GET", @url, [
      200
      "Content-Type": "application/json"
      JSON.stringify(member_test_data)
    ]
    @members = new Members

  afterEach ->
    @server.restore()

  it "should make a correct request", ->
    @members.fetch()
    expect(@server.requests.length).toEqual(1)
    expect(@server.requests[0].method).toEqual("GET")
    expect(@server.requests[0].url).toEqual(@url)