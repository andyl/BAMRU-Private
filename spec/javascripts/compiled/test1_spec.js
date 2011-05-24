(function() {
  describe("Test2", function() {
    it("really runs", function() {
      return expect('1').toEqual('1');
    });
    it("really must run 3", function() {
      return expect('6').toEqual('6');
    });
    return it("really should run", function() {
      expect('2').toEqual('2');
      return expect('2').toEqual('2');
    });
  });
}).call(this);
