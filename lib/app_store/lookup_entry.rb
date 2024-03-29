module AppStore
  class LookupEntry
    attr_accessor :average_user_rating_for_current_version, :user_rating_count_for_current_version, :average_user_rating_for_all_versions, :user_rating_count_for_all_versions, :file_size_bytes, :itunes_artwork_url,
      :release_notes, :game_center_enabled, :itunes_artwork_icon_url, :genres, :screenshots, :version, :itunes_id, :currency, :price
  end
  
  module JSON
    class LookupEntry < ::AppStore::LookupEntry
      def initialize(attributes = {})
        self.average_user_rating_for_current_version = attributes["averageUserRatingForCurrentVersion"]
        self.user_rating_count_for_current_version = attributes["userRatingCountForCurrentVersion"]
        self.average_user_rating_for_all_versions = attributes["averageUserRating"]
        self.user_rating_count_for_all_versions = attributes["userRatingCount"]
        self.file_size_bytes = attributes["fileSizeBytes"]
        self.itunes_artwork_url = attributes["artworkUrl512"]
        self.itunes_artwork_icon_url = attributes["artworkUrl60"]
        self.release_notes = attributes["releaseNotes"]
        self.game_center_enabled = attributes["isGameCenterEnabled"]
        self.genres = attributes["genres"]
        self.screenshots = attributes["screenshotUrls"]
        self.version = attributes["version"]
        self.itunes_id = attributes["trackId"].to_i
        self.price = attributes["price"]
        self.currency = attributes["currency"]
      end
    end
  end
  
  module XML
    class LookupEntry < ::AppStore::LookupEntry
      
    end
  end
  
end