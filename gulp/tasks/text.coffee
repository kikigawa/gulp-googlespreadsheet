'use strict'

# path        = require "../utils/path.coffee"
# gulp        = require 'gulp'
# del         = require 'del'
fs          = require("fs")
readline    = require('readline')
googleapis  = require('googleapis')
yaml        = require('json2yaml')

CLIENT_ID = '900708937402-r49gl85k281p09ip1gaiiakrefom3mf1.apps.googleusercontent.com'
CLIENT_SECRET = 'Q4GaIXLODndlu4578pZjRUhd'
REDIRECT_URL = 'urn:ietf:wg:oauth:2.0:oob'
SCOPE = 'https://spreadsheets.google.com/feeds'
TOKENS_FILEPATH = "./tokens.json"



class Text
  constructor: ->
    @pageCursor = 1
    # @data = {"aaa":"112aaaaaaaaaa"}
    @data = []
    @obj = {}


  start: =>
    @rl = readline.createInterface(
      input: process.stdin
      output: process.stdout
    )
    @auth = new googleapis.OAuth2Client(CLIENT_ID, CLIENT_SECRET, REDIRECT_URL)
    @readToken(@readTokenCompleted)
    # @generateYaml()


  readToken: (callback) =>
    try
      buff = fs.readFileSync(TOKENS_FILEPATH)
    catch error
      callback()
      return
    @auth.setCredentials(JSON.parse(buff.toString()))
    callback()

  readTokenCompleted: =>
    if @auth.credentials == null
      @getAccessToken(=>
        # @saveToken()
        # @parsePages()
        @getListRow(@callback)
      )
    else
      # @parsePages()
      @getListRow(@callback)
    return

  # parsePages: =>
    # @getListRow(('od6', @getcallback(PAGES[@pageCursor-1]))


  getListRow: (callback)=>
    console.log 'getListRow'
    spreadsheetsKey = '1ySjxwDwM4S8fVnSqqG1FXmJxfi61G9TezhiFCP2LMMA'
    opts = url: SCOPE + '/cells/' + spreadsheetsKey + '/od6/private/basic?alt=json'
    @auth.request opts, callback



  callback: (err, body, res) =>
    if err
      console.log err
    entry = body.feed.entry
    # @generateYaml(entry)
    # i = 0
    for i in [0..entry.length-1]
      dir = entry[i]
      type = dir.title.$t.substring(0, 1)

      switch(type)
        when 'B'
          key = dir.title.$t
          B = dir.content.$t
          url = B+'/'

        when 'C'
          key = dir.title.$t
          C = dir.content.$t
          url = B+'/'+C+'/'

        when 'D'
          key = dir.title.$t
          D = dir.content.$t
          url = B+'/'+C+'/'+D+'/'

      @generateObj(key, url)
    # @generateYaml(entry[0])

  generateObj: (key, url)=>
    @obj[key] = url
    console.log '================='
    console.log @obj
    console.log '================='

    # console.log data

    @generateYaml(@obj)








  generateYaml: (data)=>
    fs.writeFile('./gulp/data/url.json', JSON.stringify(data), ->
      console.log 'Generated text!'
    )
    # fs.writeFile('./gulp/data/url.yml', yaml.stringify(data), ->
    #   console.log 'Generated text!'
    # )
    # fs.writeFile('./app/common/data/url.json', JSON.stringify(@data[1].content.$t), ->
    #   console.log 'Generated text!'
    # )




  # callback = (err, body, res) ->
  #   if err
  #     console.log err
  #   entry = body.feed.entry
  #   i = 0
  #   while i < entry.length
  #     console.log '', entry[i]
  #     i++



module.exports = Text
