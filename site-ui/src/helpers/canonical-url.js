'use strict'

const VERSIONED_ROOT_RELATIVE_URL_RX = /^(\/[^/]+)\/[^/]+(?=\/)/

module.exports = ({ data: { root } }) => {
  const { contentCatalog, env, page, site } = root
  const siteUrl = site.url
  if (!siteUrl || siteUrl.charAt() === '/') return
  let { url, version, missing } = page.versions ? (page.latest || { url: page.url }) : page
  const latestVersion = version
  if (missing) {
    const family = 'alias'
    const baseAliasId = { component: page.component.name, module: page.module, family, relative: page.relativeSrcPath }
    let latestReached
    for (const it of page.versions) {
      if (!(latestReached || (latestReached = it.latest))) continue
      if (it.missing) {
        const alias = contentCatalog.getById({ ...baseAliasId, version: it.version })
        if (alias) {
          url = alias.rel.pub.url
          version = it.version
          break
        }
      } else {
        ;({ url, version } = it)
        break
      }
    }
  }
  const targetSiteUrl = url.charAt() === '/' ? siteUrl : page.componentVersion.asciidoc.attributes['primary-site-url']
  if (version === 'master' || version !== latestVersion) {
    return targetSiteUrl + url
  } else if (siteUrl === targetSiteUrl) {
    if (env.SUPPORTS_CURRENT_URL === 'true') return siteUrl + url.replace(VERSIONED_ROOT_RELATIVE_URL_RX, '$1/current')
    return siteUrl + url
  } else if (env.PRIMARY_SITE_SUPPORTS_CURRENT_URL === 'true') {
    return targetSiteUrl + url.substr(targetSiteUrl.length).replace(VERSIONED_ROOT_RELATIVE_URL_RX, '$1/current')
  }
  return targetSiteUrl + url
}
