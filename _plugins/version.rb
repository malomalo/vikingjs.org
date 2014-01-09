require 'json'
require 'net/http'

class Github
  def self.file_version(repo, file)
    connection = Net::HTTP.new('raw2.github.com', 443)
    connection.use_ssl = true

    req = Net::HTTP::Get.new("/#{repo}/#{file}")

    response = connection.request(req)

    response.body.split("\n")[0].match(/\d+\.\d+\.\d+/).to_s
  end
end


module Jekyll
  class VersionTag < Liquid::Tag

    def initialize(tag_name, arguments, tokens)
      super
      arguments = arguments.strip.split(' ')
      @repo = arguments[0]
      @file = arguments[1]
    end

    def render(context)
      Github.file_version(@repo, @file)
    end

  end
end

Liquid::Template.register_tag('version', Jekyll::VersionTag)