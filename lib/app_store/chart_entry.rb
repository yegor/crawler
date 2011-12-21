module AppStore
  class ChartEntry
    attr_accessor :name, :summary, :publisher, :rights, :release_date, :itunes_id
    
    def initialize(attributes = {})
      self.name = attributes[:name]
      self.summary = attributes[:summary]
      self.publisher = attributes[:publisher]
      self.rights = attributes[:rights]
      self.release_date = attributes[:release_date]
      self.itunes_id = attributes[:itunes_id]
    end
  end
  
  module JSON
    class ChartEntry < ::AppStore::ChartEntry
      def initialize(attributes = {})
        self.itunes_id = /id(\d+)/.match(attributes["id"]["label"])[1]
        
        self.name = attributes["im:name"]["label"]
        self.summary = attributes["summary"]["label"]
        # self.price = attributes["im:price"]["label"] == "Free" ? 0 : attributes["im:price"]["attributes"]["amount"].to_f
        self.release_date = Time.parse(attributes["im:releaseDate"]["label"])
        
        self.rights = attributes["rights"]["label"]
        self.publisher = attributes["im:artist"]["label"]
        
        # if attributes["link"].is_a? Hash
        #   self.screenshot_url = attributes["link"]["attributes"]["href"]
        # else
        #   self.screenshot_url = attributes["link"].last["attributes"]["href"]
        # end
        
        # self.icon_url = attributes["im:image"].last["label"]
      end
    end
  end
  
  module XML
    class ChartEntry < ::AppStore::ChartEntry
    end
  end
  
end