require 'json'
require 'net/http'

class Github
  def self.contributors(repo)
    connection = Net::HTTP.new('api.github.com', 443)
    connection.use_ssl = true
    
    req = Net::HTTP::Get.new("/repos/#{repo}/contributors")
    
    response = connection.request(req)
    
    JSON.parse(response.body)
  end
end


module Jekyll
  class ContributorsTag < Liquid::Tag

    def initialize(tag_name, arguments, tokens)
      super
      arguments = arguments.strip.split(' ')
      @repo = arguments[0]
    end
    
    

    def render(context)
      html = ''
      
      Github.contributors(@repo).each do |contributor|
        # html += contributor['login'] + "<img src=\"#{contributor["avatar_url"]}\">"
      end
      
      html
    end
    
  end
end

Liquid::Template.register_tag('contributors', Jekyll::ContributorsTag)

