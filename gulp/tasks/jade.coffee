path        = require "../utils/path.coffee"
gulp        = require 'gulp'
runSequence = require 'run-sequence'
plumber     = require 'gulp-plumber'
Config      = require "../utils/config.coffee"
gutil       = require "gulp-util"
data        = require 'gulp-data'
jade        = require 'gulp-jade'
bSync       = require './browserSync'
urls         = require '../../gulp/data/url.json'



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

gulp.task 'roop', (cb)->
  a = path.forApp
  b = path.forBuild
  console.log a
  console.log b

  gulp.src('./app'+a+'layouts/index.jade')
    .pipe plumber()
    .pipe data (file) ->
      dp  = '../utils/data.coffee'
      return require '../data/hotoke.json'
    #   out = require(dp)(file)
    #   # delete require.cache[ path.resolve(dp) ]
    #   return out

    .pipe jade
      pretty: true
    .on "error", gutil.log
    .pipe gulp.dest('./build/'+b)
    .pipe bSync.reload stream: true
  cb()

gulp.task 'jade', (cb)->
  runSequence 'roop', cb








# gulp.task 'jade', (cb)->
#   a = path.forApp
#   b = path.forBuild


#   gulp.src('./app'+a+'layouts/index.jade')
#     .pipe plumber()
#     .pipe jade
#       pretty: true
#     .on "error", gutil.log
#     .on 'end', ->
#       for key of urls
#         url = urls[key]
#         console.log url
#     .pipe gulp.dest('./build/'+b+url)
#     .pipe bSync.reload stream: true



