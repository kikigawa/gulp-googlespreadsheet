path          = require 'path'
hotokeJson    = require '../data/hotoke.json'
parentJson    = require '../data/parent.json'
childJson     = require '../data/child.json'
grandsonJson  = require '../data/grandson.json'


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


  pankz = url.split('/')
  pankz.splice(-1, 1)
  # console.log pankz
  pankzTmp = ''
  pankzArr = []
  for i in [0..pankz.length-1]
    if pankz[i]
      pankzTmp = pankzTmp+'/'+pankz[i]
      pankzArr.push(pankzTmp)
      console.log "pankz[][][]"
      console.log pankzArr
      console.log "pankz[][][]"

  





  data =
    hotoke     : hotokeJson
    parent     : parentJson
    child      : childJson
    grandson   : grandsonJson
    currentUrl : url
    id: ID
    root: ori
    pankz: pankzArr
    pankzName : pankz




  if layout is 'parent'
    p++
    if p >= parentArr.length
      p = 0

  if layout is 'child'
    c++
    if c >= childArr.length
      c = 0



  return data
