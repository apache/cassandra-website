'use strict'

module.exports = (haystack, needle) => ~(haystack || '').indexOf(needle)
