'use strict'

const VERSIONED_ROOT_RELATIVE_URL_RX = /^(\/[^/]+)\/[^/]+(?=\/)/

module.exports = ({ data: { root } }) => {
  const { contentCatalog, env, page } = root
  let { url, version, missing } = page.latest || { url: page.url }
  if (missing) {
    const latestAlias = contentCatalog.getById({
      component: page.component.name,
      version,
      module: page.module,
      family: 'alias',
      relative: page.relativeSrcPath,
    })
    if (!latestAlias) return
    url = latestAlias.rel.pub.url
  }
  if (url.charAt() === '/') {
    return env.SUPPORTS_CURRENT_URL === 'true' ? url.replace(VERSIONED_ROOT_RELATIVE_URL_RX, '$1/current') : url
  } else if (env.PRIMARY_SITE_SUPPORTS_CURRENT_URL === 'true') {
    const primarySiteUrl = page.componentVersion.asciidoc.attributes['primary-site-url']
    return primarySiteUrl + url.substr(primarySiteUrl.length).replace(VERSIONED_ROOT_RELATIVE_URL_RX, '$1/current')
  }
  return url
}
