module AppStore
  class Entry
    attr_accessor :name, :summary, :publisher, :price, :rights, :release_date, :screenshot_url, :icon_url, :itunes_id
    
    def initialize(attributes = {})
      self.name = attributes[:name]
      self.summary = attributes[:summary]
      self.publisher = attributes[:publisher]
      self.price = attributes[:price]
      self.rights = attributes[:rights]
      self.release_date = attributes[:release_date]
      self.screenshot_url = attributes[:screenshot_url]
      self.icon_url = attributes[:icon_url]
      self.itunes_id = attributes[:itunes_id]
    end
    
    def to_attributes
      returning Hash.new do |result|
        result[:name] = self.name
        result[:summary] = self.summary
        result[:price] = self.price
        result[:rights] = self.rights
        result[:publisher] = self.publisher
        result[:release_date] = self.release_date
        result[:screenshot_url] = self.screenshot_url
        result[:icon_url] = self.icon_url
        result[:itunes_id] = self.itunes_id
      end
    end
  end
  
  module JSON
    class Entry < ::AppStore::Entry
      def initialuze(attributes = {})
        self.itunes_id = /id(d+)/.match(attributes["id"]["label"])[]
        
        self.name = attributes["im:name"]["label"]
        self.summary = attributes["summary"]
        self.price = attributes["im:price"]["label"] == "Free" ? 0 : attributes["im:price"]["attributes"]["amount"].to_f
        self.release_date = Time.parse(attributes["im:releaseDate"]["label"])
        
        self.rights = attributes["rights"]["label"]
        self.publisher = attributes["im:artist"]["label"]
        
        
        self.screenshot_url = attributes["link"].last["attributes"]["href"]
        self.icon_url = attributes["im:image"].last["label"]
      end
    end
  end
  
  module XML
    class Entry < ::AppStore::Entry
    end
  end
  
end