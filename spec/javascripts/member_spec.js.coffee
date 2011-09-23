#= require tablesorter_util

describe "MemberName", ->

  beforeEach ->
    @last_name  = "Smith"
    @input_name = "Ben #{@last_name}"
    @obj        = new MemberName(@input_name)

  describe "basic object generation", ->

    it "generates an object", ->
      expect(@obj).toBeDefined()

    it "returns the input name", ->
      (expect @obj.full_name).toEqual(@input_name)

    it "updates the input name", ->
      local_name     = "New Name"
      @obj.full_name = local_name
      (expect @obj.full_name).toEqual(local_name)

  describe "#last_name", ->

    it "returns the last name", ->
      (expect @obj.last_name()).toEqual(@last_name)

  describe "when using periods in the name", ->
    beforeEach ->
      @local_name = "Dep. Joe Bob"
      @obj.full_name = @local_name

    beforeEach ->
      @local_last = "Bob"
      @local_name = "Dep. Joe #{@local_last}"
      @obj.full_name = @local_name

    it "returns the correct full_name", ->
      (expect @obj.full_name).toEqual(@local_name)

    it "returns the correct last_name", ->
      (expect @obj.last_name()).toEqual(@local_last)

describe "LinkName", ->

  beforeEach ->
    @input_name = "Ben Smith"
    @test_link  = "<a href='/x/y/z'>#{@input_name}</a>"
    @obj        = new LinkName(@test_link)

  describe "basic object generation", ->

    it "generates an object", ->
      (expect @obj).toBeDefined()

    it "returns the link", ->
      (expect @obj.link).toEqual(@test_link)

    it "updates the link", ->
      local_link = "<a href='/a/b/c'>Joe Bob</a>"
      @obj.link = local_link
      (expect @obj.link).toEqual local_link
      (expect @obj.full_name()).toEqual "Joe Bob"
      (expect @obj.last_name()).toEqual "Bob"

  describe "#full_name", ->

    it "returns the full name", ->
      (expect @obj.full_name()).toEqual @input_name

  describe "#last_name", ->

    it "returns the last name", ->
      (expect @obj.last_name()).toEqual("Smith")

  describe "when using periods in the name", ->
    beforeEach ->
      @local_last = "Bob"
      @local_name = "Dep. Joe #{@local_last}"
      @local_link = "<a href='/a/b/c'>#{@local_name}</a>"
      @obj.link = @local_link

    it "works with the link parameter", ->
      (expect @obj.link).toEqual(@local_link)

    it "returns the correct full_name", ->
      (expect @obj.full_name()).toEqual(@local_name)

    it "returns the correct last_name", ->
      (expect @obj.last_name()).toEqual(@local_last)

describe "RoleScore", ->

  beforeEach ->
    @test_string = "Bd T OL"
    @obj = new RoleScore(@test_string)

  describe "basic object generation", ->

    it "generates an object", ->
      (expect @obj).toBeDefined()

  describe ".input", ->

    it "has an input string", ->
      (expect @obj.input).toEqual(@test_string)

    it "allows the input string to be reset", ->
      local_string = "New String"
      @obj.input = local_string
      (expect @obj.input).toEqual local_string

  describe "#to_lower", ->

    it "converts the input string to a lower-case string", ->
      (expect @obj.to_lower()).toEqual @test_string.toLowerCase()

  describe "#input_array", ->

    it "has the right number of values", ->
      (expect @obj.input_array().length).toEqual 3

    it "returns lower-case strings for all values", ->
      local_string = @obj.input_array()[0]
      (expect local_string).toMatch(/^[a-z]+$/)

    it "returns a correct value for a regex sample string match", ->
      (expect "Abc").toNotMatch(/^[a-z]+$/)

  describe "#score_one", ->

    describe "when @input has a single input value", ->

      it "scores S", ->
        @obj.input = "S"
        (expect @obj.score_one()).toEqual(-10)

      it "scores A", ->
        @obj.input = "A"
        (expect @obj.score_one()).toEqual(-5)

    describe "when using a single input value as a parameter", ->

      it "scores A",       -> (expect @obj.score_one("a")).toEqual(-5)
      it "scores S",       -> (expect @obj.score_one("s")).toEqual(-10)
      it "scores R",       -> (expect @obj.score_one("r")).toEqual(-25)
      it "scores T",       -> (expect @obj.score_one("t")).toEqual(-50)
      it "scores FM",      -> (expect @obj.score_one("fm")).toEqual(-100)
      it "scores TM",      -> (expect @obj.score_one("tm")).toEqual(-250)
      it "scores OL",      -> (expect @obj.score_one("ol")).toEqual(-500)
      it "scores Bd",      -> (expect @obj.score_one("bd")).toEqual(-1000)
      it "scored unknown", -> (expect @obj.score_one("un")).toEqual(0)

  describe "#score_array", ->

    it "returns a valid array", ->
      @obj.input = "TM OL"
      (expect @obj.score_array()).toEqual([-250, -500])

  describe "#score", ->

    it "returns a valid score", ->
      @obj.input = "TM OL"
      (expect @obj.score()).toEqual(-750)



