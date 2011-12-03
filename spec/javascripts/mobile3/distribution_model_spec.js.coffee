#= require ./distribution_fixture

describe "M3_Distribution", ->
  beforeEach ->
    @dst0 = new M3_Distribution(distribution_test_data[0])
    @dst1 = new M3_Distribution(distribution_test_data[1])
    @dst2 = new M3_Distribution(distribution_test_data[2])

  describe "basic object generation (no params)", ->
    it "generates an object", -> expect(@dst0).toBeDefined()

