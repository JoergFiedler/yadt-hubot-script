chai = require 'chai'
chai.should()
chai.use require 'sinon-chai'
proxyquire = require 'proxyquire'
sinon = require 'sinon'

describe 'yadt-hubot script', ->
  beforeEach ->
    HubotYadt = require '../src/hubot-yadt'
    robot = sinon.mock()
    @hubotYadt = sinon.createStubInstance(HubotYadt)
    @constructorMock = sinon.stub()
    @constructorMock.returns(@hubotYadt)

    requireProxy =
      './hubot-yadt': @constructorMock
    script = proxyquire('../src/hubot-yadt-script', requireProxy)

    script(robot)

  it 'creates the yadt hubot instance', ->
    @constructorMock.should.have.been.calledOnce

  it 'starts the yadt hubot instance', ->
    @hubotYadt.start.should.have.been.calledOnce
