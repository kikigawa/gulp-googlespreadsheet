'use strict'

fs          = require("fs")
readline    = require('readline')
googleapis  = require('googleapis')
yaml        = require('json2yaml')

NAME = [
  'parent'
]



class Child
  constructor: ->
    console.log 'CHILD'
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
            child = dir.content.$t
            items[parent][child] = {}

          when 'C'
            value = dir.content.$t
            items[parent][child].title = value
            items[parent][child].lists = {}

          when 'D'
            console.log 'D'

          when 'E'
            item = {}
            value = dir.content.$t
            item.title = value

          when 'F'
            value = dir.content.$t
            item.text = value

          when 'G'
            value = dir.content.$t
            item.id = value

            items[parent][child].lists[item.id] = item
    callback('child', items)


module.exports = Child
