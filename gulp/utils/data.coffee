path        = require 'path'
hotokeJson  = require '../data/hotoke.json'
parentJson  = require '../data/parent.json'
childJson  = require '../data/child.json'


p = 0
c = 0


module.exports = (file, url, ID) ->

  tmp = String(file.history).split('/')
  layout = tmp[tmp.length-1].split('.')[0]

  parentArr = Object.keys(parentJson.parent)
  parentDir = parentArr[p]

  childArr = Object.keys(childJson.child)
  childDir = childArr[c]

  ori = ''
  upper = '../'
  dirLv = url.split('/').length-1
  if dirLv is 0
    ori = './'
  else
    i = 0
    while i < dirLv
      ori = ori+upper
      i++




  data =
    hotoke: hotokeJson
    parent: parentJson
    child:  childJson
    currentUrl: url
    id: ID
    root: ori



  if layout is 'parent'
    p++
    if p >= parentArr.length
      p = 0

  if layout is 'child'
    c++
    if c >= childArr.length
      c = 0



  return data
