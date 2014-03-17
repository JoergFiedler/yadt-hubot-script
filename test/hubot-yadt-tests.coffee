chai = require 'chai'
chai.should()
chai.use require 'sinon-chai'
sinon = require 'sinon'
rewire = require 'rewire'

describe 'HubotYadt', ->
  utils = require '../lib/utils'
  YadtBroadcaster = require '../lib/yadt-broadcaster'
  CmdEventHandler = require '../lib/yadt-cmd-event-handler'
  HubotYadt =  rewire '../lib/hubot-yadt'

  describe 'start()', ->

    beforeEach ->
      @robot = sinon.mock()
      @yadtBroadcaster =
        setHandlers: sinon.stub()
        connect: sinon.stub()
      @constructorMock = sinon.stub()
      @constructorMock.returns(@yadtBroadcaster)
      @config =
        broadcasterUrl: 'ws://host:port'
        topics: ['topic']
      HubotYadt.__set__('YadtBroadcaster', @constructorMock)
      @loadConfigFile = sinon.stub(utils, 'loadConfigFile')
      @loadConfigFile.returns(@config)

    afterEach ->
      @loadConfigFile.restore()

    describe 'if config is loaded', ->

      beforeEach ->
        @hubotYadt = new HubotYadt(@robot)
        @hubotYadt.start()

      it 'creates the yadt broadcaster if the config file was loaded', ->
        @constructorMock.should.have.been.calledWith(@config.broadcasterUrl, @config.topics)

      it 'sets the event handlers', ->
        @yadtBroadcaster.setHandlers.should.have.been.calledOnce
        actualHandlers = @yadtBroadcaster.setHandlers.getCall(0).args[0]
        actualHandlers[0].should.be.instanceOf(CmdEventHandler)

      it 'connects the yadt broadcaster', ->
        @yadtBroadcaster.connect.should.have.been.calledOnce

    describe 'if no config is loaded', ->

      beforeEach ->
        @loadConfigFile.returns(undefined)
        @hubotYadt = new HubotYadt(@robot)
        @hubotYadt.start()

      it 'does nothing', ->
        @constructorMock.should.not.have.been.called
