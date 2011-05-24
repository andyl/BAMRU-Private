describe "Test2", ->
  it "really runs", ->
    expect('1').toEqual('1')
  it "really must run 3", ->
    expect('6').toEqual('6')
  it "really should run", ->
    expect('2').toEqual('2')
    expect('2').toEqual('2')

