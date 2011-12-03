#= require ./distribution_fixture

describe "M3_Distribution Collection", ->
  beforeEach ->
    window.myid  = "24"
    @col = new M3_Distributions(distribution_test_data)
  describe "basic object generation (no params)", ->
    it "generates an object", -> expect(@col).toBeDefined()
