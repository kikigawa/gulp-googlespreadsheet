'use strict'

fs          = require("fs")
readline    = require('readline')
googleapis  = require('googleapis')
yaml        = require('json2yaml')

NAME = [
  'parent'
]



class Grandson
  constructor: ->
    console.log 'GRANDSON'

  value: (err, body, res, entry, callback)=>
    # wraper = {}
    items  = {}
    items.common = {}
    items.lists = {}
    gGrandsonArr = []


    for i in [0..entry.length-1]
      dir = entry[i]
      type = dir.title.$t.substring(0, 1)
      line = Number(dir.title.$t.slice(1))

      if line is 2
        switch(type)
          when 'C'
            parent = dir.content.$t
            items.common.parent = parent
          when 'D'
            child = dir.content.$t
            items.common.child = child

      else if line >= 4
        switch(type)
          when 'A'
            ID = dir.content.$t
            items.lists[ID] = {}
            item = {}
            item.id = ID
            elemArr = []

          when 'B'
            value = dir.content.$t
            item.title = value

          when 'C'
            value = dir.content.$t
            item.title_en = value

          when 'D'
            value = dir.content.$t
            item.format = value

            items.lists[ID] = item

          when 'E'
            elemType = dir.content.$t
            if elemType is 'child'
              childIs = true
            else
              childIs = false

          when 'F'
            elem = dir.content.$t
            elemArr.push({type: elemType, elem: elem})

            if childIs
              gGrandsonArr.push({me: elem, parent: ID})
              items.common.gGrandsons = gGrandsonArr

            items.lists[ID].elements = elemArr



    callback(items)


module.exports = Grandson
