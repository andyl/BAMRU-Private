#= require ./chat_fixture
#= require bchat/views/chat_index

# ----- View Specs -----

describe "BC1_ChatIndexView", ->
  beforeEach ->
    @coll =  new BC1_Chats bchat_test_data
    @model = @coll.models[0]
    @view0 = new BC1_ChatIndexView({model: @model})
    @rend0 = @view0.render()

  describe "basic object generation", ->
    it "generates a collection object", ->
      expect(@coll).toBeDefined()
    it "generates a view object", ->
      expect(@view0).toBeDefined()
    it "renders", ->
      expect(@rend0).toBeDefined()
    it "creates a container element", ->
      expect(@view0.el.nodeName).toEqual("LI")

  describe "HTML Testing", ->
    it "handles basic rendering tasks", ->
      expect($('<div>Andy</div>')).toHaveText('Andy')
      expect($('<div><b>Andy</b></div>')).toHaveText('Andy')
      expect($("<div><b>Andy</b></div>")).toContain("b")
      expect($("<div><b>Andy</b></div>")).toBe("div")
      expect($("<div class=z><b>Andy</b></div>")).toHaveClass("z")
      expect($("<div><b class=z>Andy</b></div>").children('b')).toHaveClass("z")

  describe "basic rendering", ->
    it "returns itself", ->
      expect(@rend0).toEqual(@view0)
    it "is a LI element", ->
      expect($(@rend0.el)).toBe('li')
    it "has a span element", ->
      expect($(@rend0.el)).toContain("span")
    it "has a span element with a 'created_at' class", ->
      expect($(@rend0.el).children('span')).toHaveClass('created_at')