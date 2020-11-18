;(function () {
  'use strict'

  var Mark = require('mark.js')
  window.addEventListener('load', function () {
    // Create an instance of mark.js and pass an argument containing
    // the DOM object of the context (where to search for matches)
    var markInstance = new Mark(document.querySelectorAll('.sect1'))

    /* All tutorials */
    var tiles = document.querySelectorAll('.doc .sect1')

    /* Search every time the input text is modified */
    document.getElementById('search-tutorials').addEventListener('input', function () {
      var doc = document.getElementsByClassName('doc')[0]
      var name = document.getElementById('search-tutorials').value
      var pattern = name.toLowerCase()

      markInstance.unmark({
        done: function () {
          markInstance.mark(pattern)

          var resultDivs = []
          for (var j = 0; j < tiles.length; j++) {
            /* display the card if it contains the pattern */
            if (tiles[j].querySelectorAll('mark').length > 0) {
              resultDivs.push(tiles[j])
            }
          }

          /* update list of tiles */
          doc.innerHTML = ''
          for (var k = 0; k < resultDivs.length; k++) {
            doc.appendChild(resultDivs[k])
          }

          /* if the search term is empty, return all tutorials */
          if (pattern === '') {
            doc.innerHTML = ''
            for (var i = 0; i < tiles.length; i++) {
              doc.appendChild(tiles[i])
            }
          }
        },
      })
    })
  })
})()
