;(function () {
  'use strict'

  // closes open menus in navbar on loss of focus
  window.addEventListener('click', function (e) {
    find('input.navbar-dropper').forEach(function (input) {
      if (input !== e.target) input.checked = false
    })
  })

  var nav = document.querySelector('nav.nav')
  var navMenu = {}
  if (!(navMenu.element = nav && nav.querySelector('.nav-menu'))) return
  var navControl
  var currentPageItem = navMenu.element.querySelector('.is-current-page')

  // NOTE prevent text from being selected by double click
  navMenu.element.addEventListener('mousedown', function (e) {
    if (e.detail > 1) e.preventDefault()
  })

  find('.nav-toggle', navMenu.element).forEach(function (toggleBtn) {
    var navItem = findAncestorWithClass('nav-item', toggleBtn, navMenu.element)
    toggleBtn.addEventListener('click', toggleActive.bind(navItem))
    var navItemSpan = findNextElement(toggleBtn)
    if (navItemSpan.classList.contains('nav-text')) {
      navItemSpan.style.cursor = 'pointer'
      navItemSpan.addEventListener('click', toggleActive.bind(navItem))
    }
  })

  fitNavMenuInit({})
  window.addEventListener('load', fitNavMenuInit)
  window.addEventListener('resize', fitNavMenuInit)

  if ((navControl = document.querySelector('main .nav-control'))) navControl.addEventListener('click', revealNav)

  function scrollItemToMiddle (el, parentEl) {
    var adjustment = (el.getBoundingClientRect().height - parentEl.getBoundingClientRect().height) * 0.5 + el.offsetTop
    if (adjustment > 0) parentEl.scrollTop = adjustment
  }

  function fitNavMenuInit (e) {
    window.removeEventListener('scroll', fitNavMenuOnScroll)
    navMenu.element.style.height = ''
    if ((navMenu.preferredHeight = navMenu.element.getBoundingClientRect().height) > 0) {
      // QUESTION should we check if x value > 0 instead?
      if (window.getComputedStyle(nav).visibility === 'visible') {
        if (!navMenu.encroachingElement) navMenu.encroachingElement = document.querySelector('footer.footer')
        fitNavMenu(navMenu.preferredHeight, (navMenu.viewHeight = window.innerHeight), navMenu.encroachingElement)
        window.addEventListener('scroll', fitNavMenuOnScroll)
      }
      if (currentPageItem && e.type !== 'resize') {
        scrollItemToMiddle(currentPageItem.querySelector('.nav-link'), navMenu.element)
      }
    }
  }

  function fitNavMenuOnScroll () {
    fitNavMenu(navMenu.preferredHeight, navMenu.viewHeight, navMenu.encroachingElement)
  }

  function fitNavMenu (preferredHeight, availableHeight, encroachingElement) {
    var reclaimedHeight = availableHeight - encroachingElement.getBoundingClientRect().top
    navMenu.element.style.height = reclaimedHeight > 0 ? Math.max(0, preferredHeight - reclaimedHeight) + 'px' : ''
  }

  function toggleActive (e) {
    this.classList.toggle('is-active')
    concealEvent(e)
  }

  function revealNav (e) {
    if (nav.classList.contains('is-active')) return hideNav(e)
    document.documentElement.classList.add('is-clipped--nav')
    nav.classList.add('is-active')
    nav.addEventListener('click', concealEvent)
    window.addEventListener('click', hideNav)
    concealEvent(e) // NOTE don't let event get picked up by window click listener
  }

  function hideNav (e) {
    if (e.which === 3 || e.button === 2) return
    document.documentElement.classList.remove('is-clipped--nav')
    nav.classList.remove('is-active')
    nav.removeEventListener('click', concealEvent)
    window.removeEventListener('click', hideNav)
    concealEvent(e) // NOTE don't let event get picked up by window click listener
  }

  function find (selector, from) {
    return [].slice.call((from || document).querySelectorAll(selector))
  }

  function findAncestorWithClass (className, from, scope) {
    if ((from = from.parentNode) !== scope) {
      if (from.classList.contains(className)) {
        return from
      } else {
        return findAncestorWithClass(className, from, scope)
      }
    }
  }

  function findNextElement (from, el) {
    if ((el = from.nextElementSibling)) return el
    el = from
    while ((el = el.nextSibling) && el.nodeType !== 1);
    return el
  }

  function concealEvent (e) {
    e.stopPropagation()
  }
})()
