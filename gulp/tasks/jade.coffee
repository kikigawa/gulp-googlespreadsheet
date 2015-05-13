path        = require "../utils/path.coffee"
gulp        = require 'gulp'
plumber     = require 'gulp-plumber'
Config      = require "../utils/config.coffee"
gutil       = require "gulp-util"
data        = require 'gulp-data'
jade        = require 'gulp-jade'
bSync       = require './browserSync'


# html
gulp.task 'jade', (cb)->
  a = path.forApp
  b = path.forBuild

  gulp.src('./app'+a+'layouts/index.jade')
    .pipe plumber()
    # .pipe data (file) ->
    #   dp  = '../utils/data.coffee'
    #   out = require(dp)(file)
    #   delete require.cache[ path.resolve(dp) ]
    #   return out
    .pipe jade
      pretty: true
    .on "error", gutil.log
    .pipe gulp.dest('./build/'+b)
    .pipe bSync.reload stream: true