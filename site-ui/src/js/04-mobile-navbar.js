;(function () {
  'use strict'

  document.addEventListener('DOMContentLoaded', function () {
    var navbarToggle = document.querySelector('.navbar-burger')
    if (!navbarToggle) return
    navbarToggle.addEventListener('click', function (e) {
      e.stopPropagation()
      navbarToggle.classList.toggle('is-active')
      document.getElementById(navbarToggle.dataset.target).classList.toggle('is-active')
      document.documentElement.classList.toggle('is-clipped--navbar')
    })
  })
})()
