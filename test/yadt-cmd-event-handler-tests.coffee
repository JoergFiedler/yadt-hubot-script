chai = require 'chai'
chai.should()
chai.use require 'sinon-chai'
sinon = require 'sinon'
rewire = require 'rewire'

describe 'CmdEventHandler', ->
  CmdEventHandler = rewire '../lib/yadt-cmd-event-handler'
  RoomSelector = require '../lib/room-selector'

  beforeEach ->
    @robot = sinon.spy()
    @roomSelector = sinon.createStubInstance(RoomSelector)
    constructor = sinon.stub()
    constructor.returns(@roomSelector)
    CmdEventHandler.__set__({'RoomSelector': constructor })
    @cmdEventHandler = new CmdEventHandler(@robot)

  it '', ->
    @roomSelector.createEnvelope.returns(['eins'])
    @cmdEventHandler.sendResponse({})
    console.log('done')
