'use strict'

module.exports = (langs, { data: { root } }) => {
  const { contentCatalog, page, site } = root
  const components = site.components
  const thisComponentName = page.component.name
  return langs
    .split(',')
    .map((lang) => lang + '-sdk')
    .filter((componentName) => !(componentName === thisComponentName || (components[componentName] || {}).origin))
    .map((componentName) => {
      const component = components[componentName]
      if (component) {
        const lookupContext = { component: componentName, version: component.latest.version, module: page.module }
        const relatedPage = contentCatalog && contentCatalog.resolvePage(page.relativeSrcPath, lookupContext)
        return { url: relatedPage ? relatedPage.pub.url : component.url, title: component.title }
      } else {
        return { title: componentName }
      }
    })
}
