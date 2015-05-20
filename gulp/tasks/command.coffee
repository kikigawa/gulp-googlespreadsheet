path        = require '../utils/path.coffee'
gulp        = require 'gulp'
runSequence = require 'run-sequence'
Config      = require '../utils/config'
a           = path.forApp
b           = path.forBuild
page        = path.page

Text = require "./text.coffee"

gulp.task 'default', ->
  runSequence 'clean', 'copy', 'jade', 'styles','scripts',  'delete', 'browser-sync'

gulp.task 'watch', ['default'],  ->


  gulp.watch 'app'+a+'layouts/**/*.{jade,json,coffee}', ['jade']
  gulp.watch 'app'+a+'styles/**/*.sass', ['copy','styles']
  gulp.watch 'app'+a+'scripts/**/*.coffee', ['scripts']


gulp.task 'text', ->
  text = new Text()

  text.start(page)
  # runSequence 'text'

