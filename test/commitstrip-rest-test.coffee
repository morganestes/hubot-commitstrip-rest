Helper = require('hubot-test-helper')
chai = require 'chai'
nock = require 'nock'

expect = chai.expect

helper = new Helper('../src/commitstrip-rest.coffee')

describe 'commitstrip-rest', ->
  beforeEach ->
    @room = helper.createRoom()
    do nock.disableNetConnect
    nock('https://www.commitstrip.com', {
      reqheaders: {
        'Accept': 'application/json'
      }
      })
      .get('/en/wp-json/wp/v2/posts?per_page=1&_embed')
      .reply 200, { comic: 'https://www.commitstrip.com/wp-content/uploads/2017/09/Strip-La-super-%C3%A9quipe-de-maintenance-650-finalenglish.jpg' }

  afterEach ->
    @room.destroy()
    nock.cleanAll()

  context 'user asks hubot for a commitstrip comic', ->
    beforeEach (done) ->
      @room.user.say 'alice', 'hubot commitstrip'
      setTimeout done, 100

    it 'should respond with a commitstrip comic', ->
      @room.user.say('hubot commitstrip').then =>
        console.log Object(@room.messages)
        expect(@room.messages).to.eql [
          ['alice', 'hubot commitstrip']
          ['hubot', 'https://www.commitstrip.com/wp-content/uploads/2017/09/Strip-La-super-%C3%A9quipe-de-maintenance-650-finalenglish.jpg']
        ]
