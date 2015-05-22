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
# urls         = require '../../gulp/data/url.json'
parentJson  = require '../../gulp/data/parent.json'



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


gulp.task 'jade', (cb)->
  runSequence 'hotoke', 'parent', cb



gulp.task 'hotoke',  (cb)->
  a = path.forApp
  b = path.forBuild
  gulp.src('./app'+a+'layouts/index.jade')
    .pipe plumber()
    .pipe data (file) ->
      dp  = '../utils/data.coffee'
      return require '../data/hotoke.json'
    .pipe jade
      pretty: true
    .on "error", gutil.log
    .pipe gulp.dest('./build/'+b)
    .pipe bSync.reload stream: true
  cb()



gulp.task 'parent', (cb)->
  a = path.forApp
  b = path.forBuild

  dirArr = Object.keys(parentJson.parent)
  console.log dirArr

  for i in [0..dirArr.length-1]
    dir = dirArr[i]


    gulp.src('./app'+a+'layouts/parent.jade')
      .pipe plumber()
      .pipe data (file) ->
        dp  = '../utils/data.coffee'
        return require '../data/parent.json'
      .pipe jade
        pretty: true
      .on "error", gutil.log
      .pipe rename('index.html')
      .pipe gulp.dest('./build/'+b+dir)
      .pipe bSync.reload stream: true
  cb()





# gulp.task 'parent', (cb)->
#   a = path.forApp
#   b = path.forBuild

#   dirArr = Object.keys(parentJson.parent)

#   for i in [0..dirArr.length-1]
#     dir = dirArr[i]


#   gulp.src('./app'+a+'layouts/parent.jade')
#     .pipe plumber()
#     .pipe data (file) ->
#       dp  = '../utils/data.coffee'
#       return require '../data/parent.json'
#     #   out = require(dp)(file)
#     #   # delete require.cache[ path.resolve(dp) ]
#     #   return out
#     .pipe jade
#       pretty: true
#     .on "error", gutil.log
#     .pipe gulp.dest('./build/'+b)
#     .pipe bSync.reload stream: true
#   cb()








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



