'use strict'

# path        = require "../utils/path.coffee"
# gulp        = require 'gulp'
# del         = require 'del'
fs          = require("fs")
readline    = require('readline')
googleapis  = require('googleapis')
yaml        = require('json2yaml')

Hotoke      = require "./generateJson/hotoke.coffee"


CLIENT_ID = '900708937402-r49gl85k281p09ip1gaiiakrefom3mf1.apps.googleusercontent.com'
CLIENT_SECRET = 'Q4GaIXLODndlu4578pZjRUhd'
REDIRECT_URL = 'urn:ietf:wg:oauth:2.0:oob'
SCOPE = 'https://spreadsheets.google.com/feeds'
TOKENS_FILEPATH = "./tokens.json"

NAME = [
  'hotoke'
]



class Text
  constructor: ->
    Hotoke = new Hotoke()
    @pageCursor = 1
    @data = []
    @obj = {}
    @page = null


  start: (page)=>
    @page = page
    @rl = readline.createInterface(
      input: process.stdin
      output: process.stdout
    )
    @auth = new googleapis.OAuth2Client(CLIENT_ID, CLIENT_SECRET, REDIRECT_URL)
    @readToken(@readTokenCompleted)


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
        @getListRow(@value)
      )
    else
      # @parsePages()
      @getListRow(@value)
    return


  getListRow: (callback)=>
    console.log 'getListRow'
    console.log @page
    spreadsheetsKey = '10RLsfmzuHnIpV21jtwKfw5m0OpmZ2mvOaTUkPexdO5U'

    opts = url: SCOPE + '/cells/' + spreadsheetsKey + '/od6/private/basic?alt=json'
    @auth.request opts, callback



  value: (err, body, res) =>
    if err
      console.log err
    entry = body.feed.entry

    Hotoke.value(err, body, res, entry, @generateObj)


  generateObj: (key, value)=>
    @obj[key] = value
    console.log Object.keys(@obj[key]).length
    @generateYaml(@obj)








  generateYaml: (data)=>
    fs.writeFile('./gulp/data/'+NAME[0]+'.json', JSON.stringify(data), ->
      console.log 'Generated text!'
    )
    fs.writeFile('./gulp/data/'+NAME[0]+'.yml', yaml.stringify(data), ->
      console.log 'Generated text!'
    )




module.exports = Text
