require 'open-uri'
require 'json'

module AppStore
  
  class Crawler
    class << self
      def fetch(opt = {})
        url = URI(opt[:url])

        data = JSON.parse(open(opt[:url]).read)
        
        
      end
    end
  end
  
end