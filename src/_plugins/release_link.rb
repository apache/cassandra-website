module Jekyll
  module FullReleaseLinkFilter
    def full_release_link(input)
      data = @context.registers[:site].data
      apache_url = data['urls']['apache_url']
      download_url = data['urls']['download_url']
      name = data['releases'][input]['name']
      date = data['releases'][input]['date']
      dl_link = "#{download_url}/#{name}/apache-cassandra-#{name}-bin.tar.gz"

      verif = Proc.new { |h, e| "<a href=\"#{apache_url}/dist/cassandra/#{name}/apache-cassandra-#{name}-bin.tar.gz.#{e}\">#{h}</a>" }

      pgp = verif.call("pgp", "asc")
      md5 = verif.call("md5", "md5")
      sha1 = verif.call("sha1", "sha1")
      "<a href=\"#{dl_link}\">#{name}</a> (#{pgp}, #{md5} and #{sha1}), released on #{date}"
    end
  end

  module ReleaseLinkFilter
    def release_link(input)
      data = @context.registers[:site].data
      download_url = data['urls']['download_url']
      name = data['releases'][input]['name']
      "#{download_url}/#{name}/apache-cassandra-#{name}-bin.tar.gz"
    end
  end

  module ChangelogLinkFilter
    def changelog_link(input)
      data = @context.registers[:site].data
      url = data['urls']['changelog_url']
      "#{url}-#{input}"
    end
  end
end

Liquid::Template.register_filter(Jekyll::FullReleaseLinkFilter)
Liquid::Template.register_filter(Jekyll::ReleaseLinkFilter)
Liquid::Template.register_filter(Jekyll::ChangelogLinkFilter)
