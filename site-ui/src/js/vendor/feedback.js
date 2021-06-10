;(function () {
  'use strict'

  if (Math.max(window.screen.availHeight, window.screen.availWidth) < 769) return

  window.addEventListener('load', function () {
    // var config = document.getElementById('feedback-script').dataset
    var script = document.createElement('script')
    script.src = 'https://issues.apache.org/jira/projects/CASSANDRA/issues'
    document.body.appendChild(script)
  })
})()
