#= require ./member_fixture

# ----- View Specs -----

describe "MemberShowView", ->
  beforeEach ->
    @coll =  new Members member_test_data
    @model = @coll.models[0]
    console.log @model
    @view0 = new MemberShowView({model: @model})

  describe "basic object generation", ->
    it "generates a collection object", ->
      expect(@coll).toBeDefined()
    it "generates a view object", ->
      expect(@view0).toBeDefined()
    it "creates a container element", ->
      expect(@view0.el.nodeName).toEqual("DIV")

  describe "rendering", ->
    it "returns itself", ->
      expect(@view0.render()).toEqual(@view0)
    it "produces HTML", ->
      expect($(@view0.render().el).find('div')).toBeDefined()
