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

NAME = [
  'hotoke'
]



class Hotoke
  constructor: ->
    console.log 'HOTOKE'

  value: (err, body, res, entry, callback)=>
    console.log 'Hotoke value'
    console.log '==================='
    console.log entry
    console.log '==================='
    # callback(key, url)
    for i in [0..entry.length-1]
      dir = entry[i]
      type = dir.title.$t.substring(0, 1)

      switch(type)
        when 'B'
          if dir.content.$t is 'item'
            key = dir.title.$t

        # when 'C'


      # switch(type)
      #   when 'B'
      #     key = dir.title.$t
      #     B = dir.content.$t
      #     url = B+'/'

      #   when 'C'
      #     key = dir.title.$t
      #     C = dir.content.$t
      #     url = B+'/'+C+'/'

      #   when 'D'
      #     key = dir.title.$t
      #     D = dir.content.$t
      #     url = B+'/'+C+'/'+D+'/'

      callback(key, url)





module.exports = Hotoke
