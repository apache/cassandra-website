;(function () {
  'use strict'

  if ('MozAppearance' in document.body.style) {
    Array.prototype.slice.call(document.querySelectorAll('main [id]')).forEach(function (el) {
      if (el.firstChild && ~window.getComputedStyle(el).display.indexOf('inline')) {
        var anchor = document.createElement('a')
        anchor.id = el.id
        el.removeAttribute('id')
        el.parentNode.insertBefore(anchor, el)
      }
    })
  }
})()
