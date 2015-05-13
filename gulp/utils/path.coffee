gutil   = require "gulp-util"

class UA
  constructor: ->
    @forApp = null
    @forBuild = null
    @initPath(gutil.env.type)


  initPath:(e) =>
    if e is 'sp'
      @forApp = '/sp/'
      @forBuild = '/sp/'
    if e is 'pc'
      @forApp = '/pc/'
      @forBuild = '/'
    if e is 'yt_test'
      @forApp = '/yt_test/'
      @forBuild = '/yt_test/'


module.exports = new UA()
