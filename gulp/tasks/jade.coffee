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

parentJson  = require '../data/parent.json'
childJson  = require '../data/child.json'
grandsonJson  = require '../data/grandson.json'

@a = null
@b = null

gulp.task 'jade', (cb)->
  @a = path.forApp
  @b = path.forBuild
  runSequence 'hotoke', 'parent', 'child', 'grandson', cb



gulp.task 'hotoke',  (cb)->
  gulp.src('./app'+@a+'layouts/index.jade')
    .pipe plumber()
    .pipe data (file) ->
      dp  = '../utils/data.coffee'
      out = require(dp)(file, '', '')
      return out
      # return require '../data/hotoke.json'
    .pipe jade
      pretty: true
    .on "error", gutil.log
    .pipe gulp.dest('./build/'+@b)
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
  parent    = grandsonJson.common.parent
  child     = grandsonJson.common.child
  gGrandsons = grandsonJson.common.gGrandsons

  # console.log '===========gGrandsons=========='
  # console.log gGrandsons.length
  # console.log '===========gGrandsons=========='
  me  = []
  myP = []
  for i in [0..gGrandsons.length-1]
    me.push(gGrandsons[i].me)
    myP.push(gGrandsons[i].parent)
  console.log me
  console.log myP

  dirArr = Object.keys(grandsonJson.lists)
  merge dirArr.map (id, i) ->
    imGgrandson = me.indexOf(id)

    if imGgrandson < 0
      dir = ''
    else if imGgrandson >= 0
      dir = myP[imGgrandson]+'/'


    console.log '++++++++++++++++'
    console.log dir
    console.log '++++++++++++++++'
    # format = grandsonJson.lists[id].format
    a = path.forApp
    b = path.forBuild
    gulp.src('./app'+a+'layouts/detail-noChild.jade')
      .pipe plumber()
      .pipe data (file) ->
        dp  = '../utils/data.coffee'
        out = require(dp)(file, parent+'/'+child+'/'+dir+id+'/', id)
        return out
      .pipe jade
        pretty: true
      .on "error", gutil.log
      .pipe rename('index.html')
      .pipe gulp.dest('./build/'+parent+'/'+child+'/'+dir+id)
      .pipe bSync.reload stream: true

  cb()




