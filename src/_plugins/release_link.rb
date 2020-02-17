module Jekyll
  module FullReleaseLinkFilter
    def full_release_link(input)
      data = @context.registers[:site].data
      apache_url = data['urls']['apache_url']
      download_url = data['urls']['download_url']
      name = data['releases'][input]['name']
      date = data['releases'][input]['date']
      dl_link = "#{download_url}/#{name}/apache-cassandra-#{name}-bin.tar.gz"

      verif = Proc.new { |h, e| "<a href=\"#{apache_url}/cassandra/#{name}/apache-cassandra-#{name}-bin.tar.gz.#{e}\">#{h}</a>" }

      pgp = verif.call("pgp", "asc")
      sha256 = verif.call("sha256", "sha256")
      sha512 = verif.call("sha512", "sha512")
      "<a href=\"#{dl_link}\">#{name}</a> (#{pgp}, #{sha256} and #{sha512}), released on #{date}"
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
