chai = require 'chai'
chai.should()
should = require('chai').should()
chai.use require 'sinon-chai'
sinon = require 'sinon'
Log = require 'log'

describe 'utils', ->
  utils = require '../src/utils'

  it 'configures logger', ->
    utils.logger.should.be.instanceOf(Log)

  it 'provides a load config function', ->
    utils.loadConfigFile.should.be.instanceOf(Function)

  describe 'loadConfigFile', ->
    expectedConfig = require '../test/hubot-yadt-config'
    process.env.HUBOT_YADT_CONFIG = '../test/hubot-yadt-config'

    it 'reads the config file from environment', ->
      actualConfig = utils.loadConfigFile()
      should.exist(actualConfig)
      actualConfig.should.equal(expectedConfig)
