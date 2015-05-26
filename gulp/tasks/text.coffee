'use strict'

# path        = require "../utils/path.coffee"
# gulp        = require 'gulp'
# del         = require 'del'
fs          = require("fs")
readline    = require('readline')
googleapis  = require('googleapis')
yaml        = require('json2yaml')

Hotoke      = require "./generateJson/hotoke.coffee"
Parent      = require "./generateJson/parent.coffee"
Child       = require "./generateJson/child.coffee"
Grandson    = require "./generateJson/grandson.coffee"


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
    Hotoke       = new Hotoke()
    Parent       = new Parent()
    Child        = new Child()
    Grandson     = new Grandson()
    @pageCursor  = 1
    @data        = []
    @obj         = {}
    @page        = null


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
    spreadsheetsKey = '10RLsfmzuHnIpV21jtwKfw5m0OpmZ2mvOaTUkPexdO5U'

    if @page is 'hotoke' then p = 'od6'
    if @page is 'parent' then p = '2'
    if @page is 'child' then p = '3'
    if @page is 'grandson' then p = '4'

    opts = url: SCOPE + '/cells/' + spreadsheetsKey + '/'+p+'/private/basic?alt=json'
    @auth.request opts, callback



  value: (err, body, res) =>
    if err
      console.log err
    entry = body.feed.entry

    if @page is 'hotoke'
      Hotoke.value(err, body, res, entry, @generateObj)

    if @page is 'parent'
      Parent.value(err, body, res, entry, @generateObj)

    if @page is 'child'
      Child.value(err, body, res, entry, @generateObj)

    if @page is 'grandson'
      Grandson.value(err, body, res, entry, @generateYaml)

  generateObj: (key, value)=>
    @obj[key] = value
    console.log Object.keys(@obj[key]).length
    @generateYaml(@obj)








  generateYaml: (data)=>
    fs.writeFile('./gulp/data/'+@page+'.json', JSON.stringify(data), ->
      console.log 'Generated text!'
    )
    fs.writeFile('./gulp/data/'+@page+'.yml', yaml.stringify(data), ->
      console.log 'Generated text!'
    )




module.exports = Text
