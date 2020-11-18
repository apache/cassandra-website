'use strict'

const fs = require('fs-extra')
const Octokit = require('@octokit/rest')
const path = require('path')

module.exports = (dest, bundleName, owner, repo, token, updateMaster) => async () => {
  const octokit = new Octokit({ auth: `token ${token}` })
  const {
    data: { tag_name: lastTagName },
  } = await octokit.repos.getLatestRelease({ owner, repo }).catch(() => ({ data: { tag_name: 'v0' } }))
  const tagName = `v${Number(lastTagName.substr(1)) + 1}`
  const ref = 'heads/master'
  const message = `Release ${tagName}`
  const bundleFileBasename = `${bundleName}-bundle.zip`
  const bundleFile = path.join(dest, bundleFileBasename)
  let commit = await octokit.gitdata.getRef({ owner, repo, ref }).then((result) => result.data.object.sha)
  const readmeContent = await fs
    .readFile('README.adoc', 'utf-8')
    .then((contents) => contents.replace(/^(?:\/\/)?(:current-release: ).+$/m, `$1${tagName}`))
  const readmeBlob = await octokit.gitdata
    .createBlob({ owner, repo, content: readmeContent, encoding: 'utf-8' })
    .then((result) => result.data.sha)
  let tree = await octokit.gitdata.getCommit({ owner, repo, commit_sha: commit }).then((result) => result.data.tree.sha)
  tree = await octokit.gitdata
    .createTree({
      owner,
      repo,
      tree: [{ path: 'README.adoc', mode: '100644', type: 'blob', sha: readmeBlob }],
      base_tree: tree,
    })
    .then((result) => result.data.sha)
  commit = await octokit.gitdata
    .createCommit({ owner, repo, message, tree, parents: [commit] })
    .then((result) => result.data.sha)
  if (updateMaster) await octokit.gitdata.updateRef({ owner, repo, ref, sha: commit })
  const uploadUrl = await octokit.repos
    .createRelease({
      owner,
      repo,
      tag_name: tagName,
      target_commitish: commit,
      name: tagName,
    })
    .then((result) => result.data.upload_url)
  await octokit.repos.uploadReleaseAsset({
    url: uploadUrl,
    file: fs.createReadStream(bundleFile),
    name: bundleFileBasename,
    headers: {
      'content-length': (await fs.stat(bundleFile)).size,
      'content-type': 'application/zip',
    },
  })
}
