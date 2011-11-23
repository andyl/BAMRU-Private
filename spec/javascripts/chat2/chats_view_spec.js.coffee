#= require ./chat_fixture
#= require chat2/views/chat_index
#= require chat2/views/chats_index

# ----- View Specs -----

describe "C2_ChatsIndexView", ->
  beforeEach ->
    @coll =  new C2_Chats chat_test_data
    @model = @coll.models[0]
    @view0 = new C2_ChatsIndexView()

  describe "basic object generation", ->
    it "generates a collection object", ->
      expect(@coll).toBeDefined()
    it "generates a view object", ->
      expect(@view0).toBeDefined()
#    it "generates an element", ->
#      console.log @view0
#      console.log @view0.el
#      expect(@view0.el).toBeDefined()
#    it "has an element with a nodeName", ->
#      expect(@view0.el.nodeName).toBeDefined()
#    it "creates a container element", ->
#      expect(@view0.el.nodeName).toEqual("DIV")

#  describe "basic rendering", ->
#    it "returns itself", ->
#      expect(@view0.render()).toEqual(@view0)
#    it "produces HTML", ->
#      expect($(@view0.render().el).find('div')).toBeDefined()
#      expect($('<div>Andy</div>')).toHaveText('Andy')
#      expect($('<div><b>Andy</b></div>')).toHaveText('Andy')
#      expect($("<div><b>Andy</b></div>")).toContain("b")
#      expect($(@view0.render().el)).toContain("b")
#      expect($(@view0.render().el)).toBe("div")
