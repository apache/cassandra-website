;(function () {
  'use strict'

  find('[data-video-carousel]').forEach(function (carousel) {
    var track = carousel.querySelector('[data-video-carousel-track]')
    var prevBtn = carousel.querySelector('[data-video-carousel-prev]')
    var nextBtn = carousel.querySelector('[data-video-carousel-next]')
    if (!track || !prevBtn || !nextBtn) return

    prevBtn.addEventListener('click', function () {
      track.scrollBy({ left: -pageWidth() })
    })

    nextBtn.addEventListener('click', function () {
      track.scrollBy({ left: pageWidth() })
    })

    track.addEventListener('scroll', updateArrows)
    window.addEventListener('resize', updateArrows)
    updateArrows()

    function pageWidth () {
      var item = track.querySelector('[class~="video-carousel__item"]')
      return item ? item.getBoundingClientRect().width + 20 : track.clientWidth
    }

    function updateArrows () {
      var maxScroll = track.scrollWidth - track.clientWidth
      prevBtn.disabled = track.scrollLeft <= 1
      nextBtn.disabled = track.scrollLeft >= maxScroll - 1
    }
  })

  function find (selector, from) {
    return [].slice.call((from || document).querySelectorAll(selector))
  }
})()
