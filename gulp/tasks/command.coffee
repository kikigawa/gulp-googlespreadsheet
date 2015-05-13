path        = require '../utils/path.coffee'
gulp        = require 'gulp'
runSequence = require 'run-sequence'
Config      = require '../utils/config'
a           = path.forApp
b           = path.forBuild

gulp.task 'default', ->
  console.log '/////////////////////////'
  console.log '/////////////////////////'
  console.log '////////default//////////'
  console.log '/////////////////////////'
  console.log '/////////////////////////'


  runSequence 'clean', 'copy', 'jade','styles','scripts', 'delete', 'browser-sync'

gulp.task 'watch', ['default'],  ->


  gulp.watch 'app'+a+'layouts/**/*.{jade,json,coffee}', ['jade']
  gulp.watch 'app'+a+'styles/**/*.sass', ['copy','styles']
  gulp.watch 'app'+a+'scripts/**/*.coffee', ['scripts']


gulp.task 'text', ->
  runSequence 'text'

