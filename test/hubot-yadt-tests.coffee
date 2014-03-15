chai = require 'chai'
chai.should()
chai.use require 'sinon-chai'
proxyquire = require 'proxyquire'
sinon = require 'sinon'

describe 'yadt-hubot script', ->
  beforeEach ->
    YadtHubot = require '../src/hubot-yadt'
    robot = sinon.mock()
    @yadtHubot = sinon.createStubInstance(YadtHubot)
    @constructorMock = sinon.stub()
    @constructorMock.returns(@yadtHubot)

    requireProxy =
      './hubot-yadt': @constructorMock
    script = proxyquire('../src/hubot-yadt-script', requireProxy)

    script(robot)

  it 'creates the yadt hubot instance', ->
    @constructorMock.should.have.been.calledOnce

  it 'starts the yadt hubot instance', ->
    @yadtHubot.start.should.have.been.calledOnce
