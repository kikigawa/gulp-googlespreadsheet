path        = require 'path'
parentJson  = require '../data/parent.json'


i = 0

module.exports = (file) ->
  # root      = "/Users/Kiki/Documents/works/quiksilver/repos/app/pc/layouts/"
  # dir       = path.dirname file.path
  # relative  = path.relative dir, root
  # name      = path.relative(root, dir)

  # if name is ""
  #   name      = "index"
  #   relative  = "."
  console.log i
  dirArr = Object.keys(parentJson.parent)
  dir = dirArr[i]
  data =
    parent: parentJson
    url: dir

  i++
  if i >= dirArr.length
    i = 0



  return data
