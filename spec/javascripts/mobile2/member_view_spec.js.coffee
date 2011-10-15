#= require ./member_fixture

# ----- View Specs -----

describe "MemberShowView", ->
  beforeEach ->
    window.is_phone = "true"
    @coll =  new Members member_test_data
    @model = @coll.models[0]
    @view0 = new MemberShowView({model: @model})

  describe "basic object generation", ->
    it "generates a collection object", ->
      expect(@coll).toBeDefined()
    it "generates a view object", ->
      expect(@view0).toBeDefined()
    it "creates a container element", ->
      expect(@view0.el.nodeName).toEqual("DIV")

  describe "basic rendering", ->
    it "returns itself", ->
      expect(@view0.render()).toEqual(@view0)
    it "produces HTML", ->
      expect($(@view0.render().el).find('div')).toBeDefined()
      expect($('<div>Andy</div>')).toHaveText('Andy')
      expect($('<div><b>Andy</b></div>')).toHaveText('Andy')
      expect($("<div><b>Andy</b></div>")).toContain("b")
      expect($(@view0.render().el)).toContain("b")
      expect($(@view0.render().el)).toBe("div")
