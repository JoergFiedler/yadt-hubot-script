chai = require 'chai'
chai.should()
chai.use require 'sinon-chai'
sinon = require 'sinon'
proxyquire = require 'proxyquire'

describe 'HubotYadt', ->
  utils = require '../lib/utils'
  YadtBroadcaster = require '../lib/yadt-broadcaster'
  CmdEventHandler = require '../lib/yadt-cmd-event-handler'

  describe 'start()', ->
    beforeEach ->
      @yadtBroadcaster = sinon.createStubInstance(YadtBroadcaster)
      @constructorStub = sinon.stub()
      @constructorStub.returns(@yadtBroadcaster)

    describe 'if config is loaded', ->

      beforeEach ->
        robot = sinon.mock()
        @config =
          broadcasterUrl: 'ws://host:port'
          topics: ['topic']
        @loadConfigFile = sinon.stub(utils, 'loadConfigFile')
        @loadConfigFile.returns(@config)
        moduleStub =
          './yadt-broadcaster': @constructorStub
        HubotYadt = proxyquire('../lib/hubot-yadt', moduleStub)
        @hubotYadt = new HubotYadt(robot)
        @hubotYadt.start()

      afterEach ->
        @loadConfigFile.restore()

      it 'creates the yadt broadcaster if the config file was loaded', ->
        @constructorStub.should.have.been.calledWith(@config.broadcasterUrl, @config.topics)

      it 'sets the event handlers', ->
        @yadtBroadcaster.setHandlers.should.have.been.calledOnce
        actualHandlers = @yadtBroadcaster.setHandlers.getCall(0).args[0]
        actualHandlers[0].should.be.instanceOf(CmdEventHandler)

      it 'connects the yadt broadcaster', ->
        @yadtBroadcaster.connect.should.have.been.calledOnce

    describe 'if no config is loaded', ->

      beforeEach ->
        robot = sinon.mock()
        @loadConfigFile = sinon.stub(utils, 'loadConfigFile')
        @loadConfigFile.returns(undefined)
        moduleStub =
          './yadt-broadcaster': @constructorStub
        HubotYadt = proxyquire('../lib/hubot-yadt', moduleStub)
        @hubotYadt = new HubotYadt(robot)
        @hubotYadt.start()

      afterEach ->
        @loadConfigFile.restore()

      it 'does nothing', ->
        @loadConfigFile.returns(undefined)
        @constructorStub.should.not.have.been.called
