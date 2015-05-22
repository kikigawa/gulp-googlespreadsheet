path    = require 'path'
hotoke  = require '../data/url.json'



module.exports = (file) ->
  root      = "/Users/Kiki/Documents/works/quiksilver/repos/app/pc/layouts/"
  dir       = path.dirname file.path
  relative  = path.relative dir, root
  name      = path.relative(root, dir)

  if name is ""
    name      = "index"
    relative  = "."

  data =
    pickup: hotoke
    # id: name
    # root: relative

  aaa = 'aaaaa'


  return data
