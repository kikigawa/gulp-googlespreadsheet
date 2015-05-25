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

# urls         = require '../../gulp/data/url.json'
parentJson  = require '../data/parent.json'
childJson  = require '../data/child.json'



# gulp.task 'roop', (cb)->
#   a = path.forApp
#   b = path.forBuild
#   console.log a
#   console.log b
#   for key of urls
#     url = urls[key]
#     console.log url
#     gulp.src('./app'+a+'layouts/index.jade')
#       .pipe plumber()
#       .pipe jade
#         pretty: true
#       .on "error", gutil.log
#       .pipe gulp.dest('./build/'+b+url)
#       .pipe bSync.reload stream: true
#   cb()

@a = null
@b = null

gulp.task 'jade', (cb)->
  @a = path.forApp
  @b = path.forBuild
  runSequence 'hotoke', 'parent', 'child', cb



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
          # return childJson
        .pipe jade
          pretty: true
        .on "error", gutil.log
        .pipe rename('index.html')
        .pipe gulp.dest('./build/'+b+parent+'/'+dir)
        .pipe bSync.reload stream: true
  cb()



