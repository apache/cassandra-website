;(function () {
  'use strict'

  var docsearch = require('docsearch.js/dist/cdn/docsearch.js')
  window.addEventListener('load', function () {
    var config = document.getElementById('search-script').dataset
    var link = document.createElement('link')
    link.rel = 'stylesheet'
    link.href = config.stylesheet
    document.head.appendChild(link)
    var ds = docsearch({
      appId: config.appId,
      apiKey: config.apiKey,
      indexName: config.indexName,
      inputSelector: '#search-query',
      algoliaOptions: { hitsPerPage: 25 },
      debug: false,
    })
    document.querySelector('button.search').addEventListener('click', function (e) {
      if (document.querySelector('.navbar-start').classList.toggle('reveal-search-input')) {
        ds.autocomplete.autocomplete.setVal('')
        ds.input.focus()
      }
    })
  })
})()
