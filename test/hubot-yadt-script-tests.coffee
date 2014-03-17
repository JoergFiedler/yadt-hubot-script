chai = require 'chai'
chai.should()
chai.use require 'sinon-chai'
rewire = require 'rewire'
sinon = require 'sinon'

describe 'yadt-hubot script', ->
  script = rewire '../src/hubot-yadt-script'

  beforeEach ->
    robot = sinon.mock()
    @hubotYadt =
      start: sinon.spy()
    @constructorMock = sinon.stub()
    @constructorMock.returns(@hubotYadt)

    script.__set__({'HubotYadt': @constructorMock })

    script(robot)

  it 'creates the yadt hubot instance', ->
    @constructorMock.should.have.been.calledOnce

  it 'starts the yadt hubot instance', ->
    @hubotYadt.start.should.have.been.calledOnce
