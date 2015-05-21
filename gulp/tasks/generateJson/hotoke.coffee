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

    for i in [0..entry.length-1]
      dir = entry[i]
      type = dir.title.$t.substring(0, 1)

      switch(type)
        when 'A'
          parent = dir.content.$t
          if parent is 'pickup'
            check = true
            pickup = {}

        when 'B'
          if check is true
            item = {}

        when 'C'
          if check is true
            value = dir.content.$t
            item.title = value

        when 'D'
          if check is true
            value = dir.content.$t
            item.subtitle = value

        when 'E'
          if check is true
            value = dir.content.$t
            item.url = value

        when 'F'
          if check is true
            value = dir.content.$t
            item.target = value

        when 'G'
          if check is true
            value = dir.content.$t
            key = value
            item.id = value

        when 'H'
          if check is true
            value = dir.content.$t
            item.type = value
            pickup[key] = item


    callback('pickup', pickup)





module.exports = Hotoke
