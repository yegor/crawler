module AppStore
  module RSS
    COUNTRIES = {"Algeria"=>"DZ", "Angola"=>"AO", "Anguilla"=>"AI", "Antigua and Barbuda"=>"AG", "Argentina"=>"AR", "Armenia"=>"AM", "Australia"=>"AU", "Austria"=>"AT", "Azerbaijan"=>"AZ", 
      "Bahamas"=>"BS", "Bahrain"=>"BH", "Barbados"=>"BB", "Belarus"=>"BY", "Belgium"=>"BE", "Belize"=>"BZ", "Bermuda"=>"BM", "Bolivia"=>"BO", "Botswana"=>"BW", "Brazil"=>"BR", 
      "British Virgin Islands"=>"VG", "Brunei Darussalam"=>"BN", "Bulgaria"=>"BG", "Canada"=>"CA", "Cayman Islands"=>"KY", "Chile"=>"CL", "China"=>"CN", "Colombia"=>"CO", "Costa Rica"=>"CR", 
      "Croatia"=>"HR", "Cyprus"=>"CY", "Czech Republic"=>"CZ", "Denmark"=>"DK", "Dominica"=>"DM", "Dominican Republic"=>"DO", "Ecuador"=>"EC", "Egypt"=>"EG", "El Salvador"=>"SV", 
      "Estonia"=>"EE", "Finland"=>"FI", "France"=>"FR", "Germany"=>"DE", "Ghana"=>"GH", "Greece"=>"GR", "Grenada"=>"GD", "Guatemala"=>"GT", "Guyana"=>"GY", "Honduras"=>"HN", 
      "Hong Kong"=>"HK", "Hungary"=>"HU", "Iceland"=>"IS", "India"=>"IN", "Indonesia"=>"ID", "Ireland"=>"IE", "Israel"=>"IL", "Italy"=>"IT", "Jamaica"=>"JM", "Japan"=>"JP", "Jordan"=>"JO", 
      "Kazakstan"=>"KZ", "Kenya"=>"KE", "Korea"=>"KR", "Kuwait"=>"KW", "Latvia"=>"LV", "Lebanon"=>"LB", "Lithuania"=>"LT", "Luxembourg"=>"LU", "Macau"=>"MO", "Macedonia"=>"MK", 
      "Madagascar"=>"MG", "Malaysia"=>"MY", "Mali"=>"ML", "Malta"=>"MT", "Mauritius"=>"MU", "Mexico"=>"MX", "Moldova"=>"MD", "Montserrat"=>"MS", "Netherlands"=>"NL", "New Zealand"=>"NZ", 
      "Nicaragua"=>"NI", "Niger"=>"NE", "Nigeria"=>"NG", "Norway"=>"NO", "Oman"=>"OM", "Pakistan"=>"PK", "Panama"=>"PA", "Paraguay"=>"PY", "Peru"=>"PE", "Philippines"=>"PH", "Poland"=>"PL", 
      "Portugal"=>"PT", "Qatar"=>"QA", "Romania"=>"RO", "Russia"=>"RU", "Saudi Arabia"=>"SA", "Senegal"=>"SN", "Singapore"=>"SG", "Slovakia"=>"SK", "Slovenia"=>"SI", "South Africa"=>"ZA", 
      "Spain"=>"ES", "Sri Lanka"=>"LK", "St. Kitts and Nevis"=>"KN", "St. Lucia"=>"LC", "St. Vincent and The Grenadines"=>"VC", "Suriname"=>"SR", "Sweden"=>"SE", "Switzerland"=>"CH", 
      "Taiwan"=>"TW", "Tanzania"=>"TZ", "Thailand"=>"TH", "Trinidad and Tobago"=>"TT", "Tunisia"=>"TN", "Turkey"=>"TR", "Turks and Caicos Islands"=>"TC", "Uganda"=>"UG", "United Kingdom"=>"GB", 
      "United Arab Emirates"=>"AE", "Uruguay"=>"UY", "United States"=>"US", "Uzbekistan"=>"UZ", "Venezuela"=>"VE", "Vietnam"=>"VN", "Yemen"=>"YE"}
    
    KINDS = ["topfreeapplications", "toppaidapplications", "topgrossingapplications", "topfreeipadapplications", "toppaidipadapplications", "topgrossingipadapplications", "newapplications", "newfreeapplications", "newpaidapplications"]
    
    GENRES = {"books"=>"6018", "business"=>"6000", "education"=>"6017", "entertainment"=>"6016", "finance"=>"6015", "games"=>"6014", " fitness"=>"6013",
      "lifestyle"=>"6012", "medical"=>"6020", "music"=>"6011", "navigation"=>"6010", "news"=>"6009", "newsstand"=>"6021", " video"=>"6008",
      "productivity"=>"6007", "reference"=>"6006", "social networking"=>"6005", "sports"=>"6004", "travel"=>"6003", "utilities"=>"6002", "weather"=>"6001"}
    
    class << self
      def url_for(opt = {})
        country = COUNTRIES[opt[:country]] || "US"
        format = opt[:format] || "json"
        genre = opt[:genre].blank? ? "" : "genre=#{GENRES[opt[:genre]]}/"
        limit = opt[:limit] || 400
        kind = KINDS.include?(opt[:kind]) ? opt[:kind] : "toppaidapplications"
        
        URI("http://itunes.apple.com/#{country}/rss/#{kind}/limit=#{limit}/#{genre}#{format}")
      end
    end
  end
end