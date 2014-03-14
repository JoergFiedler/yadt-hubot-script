chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'yadt-hubot', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()
    @yadtHubot = require('../src/yadt-hubot')(@robot)

  it 'returns true', ->
    expect(@yadtHubot).to.equal(true)
