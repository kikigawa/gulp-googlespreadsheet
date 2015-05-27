path        = require "../utils/path.coffee"
gulp        = require 'gulp'
runSequence = require 'run-sequence'
plumber     = require 'gulp-plumber'
Config      = require "../utils/config.coffee"
gutil       = require "gulp-util"
data        = require 'gulp-data'
jade        = require 'gulp-jade'
rename      = require 'gulp-rename'
bSync       = require './browserSync'
merge       = require('merge-stream')
fs = require('fs')

parentJson  = require '../data/parent.json'
childJson  = require '../data/child.json'
# grandsonJson  = require '../data/grandson.json'


a = null
b = null

grandsonFileList = []

gulp.task 'jade', (cb)->
  a = path.forApp
  b = path.forBuild
  runSequence 'checkJson', 'hotoke', 'parent', 'child', 'grandson', cb


gulp.task 'checkJson', (cb)->
  #Grandson*.jsonを取得
  jsonDir = './gulp/data/'
  fs.readdir jsonDir, (err, files) ->
    if err
      throw err

    files.filter((file) ->
      fs.statSync(jsonDir+file).isFile() and /grandson.*\.json$/.test(file)
    ).forEach (file) ->
      grandsonFileList.push file
      return
    cb()



gulp.task 'hotoke',  (cb)->
  gulp.src('./app'+a+'layouts/index.jade')
    .pipe plumber()
    .pipe data (file) ->
      dp  = '../utils/data.coffee'
      out = require(dp)(file, '', '')
      return out
    .pipe jade
      pretty: true
    .on "error", gutil.log
    .pipe gulp.dest('./build/'+b)
    .pipe bSync.reload stream: true
  cb()




gulp.task 'parent', (cb)->
  dirArr = Object.keys(parentJson.parent)
  merge dirArr.map (dir) ->
    a = path.forApp
    b = path.forBuild
    gulp.src('./app'+a+'layouts/parent.jade')
      .pipe plumber()
      .pipe data (file) ->
        dp  = '../utils/data.coffee'
        out = require(dp)(file, dir+'/', dir)
        return out
      .pipe jade
        pretty: true
      .on "error", gutil.log
      .pipe rename('index.html')
      .pipe gulp.dest('./build/'+b+dir)
      .pipe bSync.reload stream: true

  cb()





gulp.task 'child', (cb)->
  parentArr = Object.keys(childJson.child)
  merge parentArr.map (parent) ->
    dirArr = Object.keys(childJson.child[parent])
    merge dirArr.map (dir) ->
      a = path.forApp
      b = path.forBuild
      gulp.src('./app'+a+'layouts/child.jade')
        .pipe plumber()
        .pipe data (file) ->
          dp  = '../utils/data.coffee'
          out = require(dp)(file, parent+'/'+dir+'/', dir)
          return out
        .pipe jade
          pretty: true
        .on "error", gutil.log
        .pipe rename('index.html')
        .pipe gulp.dest('./build/'+b+parent+'/'+dir)
        .pipe bSync.reload stream: true
  cb()




gulp.task 'grandson', (cb)->
  console.log '+++++++++++++++++++++++'
  console.log grandsonFileList
  console.log '+++++++++++++++++++++++'

  merge grandsonFileList.map (name, i) ->


    json = require '../data/'+grandsonFileList[i]
    parent    = json.common.parent
    child     = json.common.child
    gGrandsons = json.common.gGrandsons

    me  = []
    myParent = []
    for i in [0..gGrandsons.length-1]
      me.push(gGrandsons[i].me)
      myParent.push(gGrandsons[i].parent)

    dirArr = Object.keys(json.lists)
    console.log dirArr
    merge dirArr.map (id, i) ->
      imGgrandson = me.indexOf(id)

      if imGgrandson < 0
        dir = ''
      else if imGgrandson >= 0
        dir = myParent[imGgrandson]+'/'

      a = path.forApp
      b = path.forBuild
      gulp.src('./app'+a+'layouts/detail.jade')
        .pipe plumber()
        .pipe data (file) ->
          dp  = '../utils/data.coffee'
          out = require(dp)(file, parent+'/'+child+'/'+dir+id+'/', id, json)
          return out
        .pipe jade
          pretty: true
        .on "error", gutil.log
        .pipe rename('index.html')
        .pipe gulp.dest('./build/'+parent+'/'+child+'/'+dir+id)
        .pipe bSync.reload stream: true
  cb()
