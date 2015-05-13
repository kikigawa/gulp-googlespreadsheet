# $ ->
#   alert 'aaa'
#   $('body').css 'opacity', '0'



module.exports =

  class PC

    constructor: ->
        TweenMax.set($('h1'), {rotation:-3, scale: 0.5})
        TweenMax.to($('h1'), 1, {rotation: 0, scale: 1, ease:Elastic.easeOut})

$ ->
  new PC()
