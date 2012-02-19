module AppStore
  module ChartConfig
    
    def self.included(base)
      base.extend URI
    end
    
    ITUNES_LOOKUP_BASE_URL = "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsLookup"
    
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
      
    COUNTRY_TO_STORE_FRONTS = {"Canada" => "143455-6,12", "United States" => "143441-1,12", "Belarus" => "143565,12", 
        "Belgium" => "143446-2,12", "Bulgaria" => "143526,12", "Croatia" => "143494,12", "Cyprus" => "143557-2,12", 
        "Czech Republic" => "143489,12", "Denmark" => "143458-2,12", "Germany" => "143443,12", "Spain" => "143454-8,12", 
        "Estonia" => "143518,12", "Finland" => "143447-2,12", "France" => "143442,12", "Greece" => "143448,12", "Hungary" => "143482,12", 
        "Iceland" => "143558,12", "Ireland" => "143449,12", "Italy" => "143450,12", "Latvia" => "143519,12", "Lithuania" => "143520,12", 
        "Luxembourg" => "143451-2,12", "Macedonia" => "143530,12", "Malta" => "143521,12", "Moldova" => "143523,12", 
        "Netherlands" => "143452,12", "Norway" => "143457-2,12", "Austria" => "143445,12", "Poland" => "143478,12", 
        "Portugal" => "143453,12", "Romania" => "143487,12", "Slovakia" => "143496,12", "Slovenia" => "143499,12", 
        "Sweden" => "143456,12", "Switzerland" => "143459-2,12", "Turkey" => "143480,12", "United Kingdom" => "143444,12", 
        "Russia" => "143469,12", "Algeria" => "143563,12", "Angola" => "143564,12", "Armenia" => "143524,12", "Azerbaijan" => "143568,12", 
        "Bahrain" => "143559,12", "Botswana" => "143525,12", "Egypt" => "143516,12", "Ghana" => "143573,12", "India" => "143467,12", 
        "Israel" => "143491,12", "Jordan" => "143528,12", "Kenya" => "143529,12", "Kuwait" => "143493,12", "Lebanon" => "143497,12", 
        "Madagascar" => "143531,12", "Mali" => "143532,12", "Mauritius" => "143533,12", "Niger" => "143534,12", "Nigeria" => "143561,12", 
        "Oman" => "143562,12", "Qatar" => "143498,12", "Saudi Arabia" => "143479,12", "Senegal" => "143535,12", 
        "South Africa" => "143472,12", "Tanzania" => "143572,12", "Tunisia" => "143536,12", "United Arab Emirates" => "143481,12", 
        "Uganda" => "143537,12", "Yemen" => "143571,12", "Australia" => "143460,12", "Brunei Darussalam" => "143560,12", 
        "China" => "143465-2,12", "Hong Kong" => "143463,12", "Indonesia" => "143476,12", "Japan" => "143462-1,12", 
        "Kazakstan" => "143517,12", "Macau" => "143515,12", "Malaysia" => "143473,12", "New Zealand" => "143461,12", 
        "Pakistan" => "143477,12", "Philippines" => "143474,12", "Singapore" => "143464,12", "Sri Lanka" => "143486,12", 
        "Taiwan" => "143470,12", "Thailand" => "143475,12", "Uzbekistan" => "143566,12", "Vietnam" => "143471,12", 
        "Korea" => "143466,12", "Anguilla" => "143538,12", "Antigua and Barbuda" => "143540,12", "Argentina" => "143505-2,12", 
        "Bahamas" => "143539,12", "Barbados" => "143541,12", "Belize" => "143555-2,12", "Bermuda" => "143542,12", "Bolivia" => "143556-2,12", 
        "Brazil" => "143503,12", "British Virgin Islands" => "143543,12", "Cayman Islands" => "143544,12", "Chile" => "143483-2,12", 
        "Colombia" => "143501-2,12", "Costa Rica" => "143495-2,12", "Dominica" => "143545,12", "Dominican Republic" => "143508-2,12", 
        "Ecuador" => "143509-2,12", "El Salvador" => "143506-2,12", "Grenada" => "143546,12", "Guatemala" => "143504-2,12", 
        "Guyana" => "143553,12", "Honduras" => "143510-2,12", "Jamaica" => "143511,12", "Mexico" => "143468,12", "Montserrat" => "143547,12", 
        "Nicaragua" => "143512-2,12", "Panama" => "143485-2,12", "Paraguay" => "143513-2,12", "Peru" => "143507-2,12", 
        "St. Kitts and Nevis" => "143548,12", "St. Lucia" => "143549,12", "St. Vincent and The Grenadines" => "143550,12", 
        "Suriname" => "143554-2,12", "Trinidad and Tobago" => "143551,12", "Turks and Caicos Islands" => "143552,12", "Uruguay" => "143514-2,12", 
        "Venezuela" => "143502-2,12"}
      
    SUPER_COUNTRIES = ["Australia", "Canada", "China", "France", "Germany", "Japan", "Korea", "Indonesia", "United Kingdom", "United States"]
    
    KINDS = ["topfreeapplications", "toppaidapplications", "topgrossingapplications", "topfreeipadapplications", "toppaidipadapplications", "topgrossingipadapplications", "newapplications", "newfreeapplications", "newpaidapplications"]
    
    SUPER_KINDS = ["topfreeapplications", "toppaidapplications", "topgrossingapplications", "topfreeipadapplications", "toppaidipadapplications", "topgrossingipadapplications"]
    
    GENRES = {"books"=>"6018", "business"=>"6000", "education"=>"6017", "entertainment"=>"6016", "finance"=>"6015", "games"=>"6014", " fitness"=>"6013",
      "lifestyle"=>"6012", "medical"=>"6020", "music"=>"6011", "navigation"=>"6010", "news"=>"6009", "newsstand"=>"6021", " video"=>"6008",
      "productivity"=>"6007", "reference"=>"6006", "social networking"=>"6005", "sports"=>"6004", "travel"=>"6003", "utilities"=>"6002", "weather"=>"6001"}
      
    SUPER_GENRES = ["games", nil]
    
    module URI
      def url_for(opt = {})
        country = COUNTRIES[opt[:country]] || "US"
        format = opt[:format] || "json"
        genre = opt[:genre].blank? ? "" : "genre=#{GENRES[opt[:genre]]}/"
        limit = opt[:limit] || 10
        kind = KINDS.include?(opt[:kind]) ? opt[:kind] : "toppaidapplications"

        URI("http://itunes.apple.com/#{country}/rss/#{kind}/limit=#{limit}/#{genre}#{format}")
      end
    end
  end
end