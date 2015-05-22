'use strict'

# path        = require "../utils/path.coffee"
# gulp        = require 'gulp'
# del         = require 'del'
fs          = require("fs")
readline    = require('readline')
googleapis  = require('googleapis')
yaml        = require('json2yaml')

NAME = [
  'parent'
]



class Parent
  constructor: ->
    console.log 'PARENT'
    # @itemNum = 0

  value: (err, body, res, entry, callback)=>
    items = {}

    for i in [0..entry.length-1]
      dir = entry[i]
      type = dir.title.$t.substring(0, 1)
      line = dir.title.$t.slice(1)

      if line != '1'
        switch(type)
          when 'A'
            parent = dir.content.$t
            items[parent] = {}

          when 'B'
            item = {}

          when 'C'
            value = dir.content.$t
            item.tag = value

          when 'D'
            value = dir.content.$t
            item.title = value

          when 'E'
            value = dir.content.$t
            item.text = value

          when 'F'
            value = dir.content.$t
            item.id = value

            items[parent][item.id] = item
    callback('parent', items)







module.exports = Parent
