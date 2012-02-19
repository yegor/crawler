require "open-uri"
require "hpricot"
require "net/http"

module AppStore
  
  class ItunesStore
    
    class << self
      
      include AppStore::ChartConfig
      
      ITUNES_MAIN_PAGE_URL = "/WebObjects/MZStore.woa/wa/viewGrouping?id=25204&mt=8"
      
      ITUNES_UA_HEADERS = {"User-Agent" => "iTunes/10.5.2"}
      ITUNES_IPHONE_URL_SUFFIX = "&pillIdentifier=iphone"
      ITUNES_IPAD_URL_SUFFIX = "&pillIdentifier=ipad"
      
      SUPER_FEATURING_CSS_PATH = "body .content .showcase a"
      BRICK_FEATURING_BRICK_CSS_PATH = "body .content .bricks a"
      SWOOSH_FEATURING_BRICK_CSS_PATH = "body .content .lockup a.artwork-link"
      
      CATEGORIES_CSS_PATH = "body .right-stack form select option"
      QUICK_LINKS_CSS_PATH = "body .right-stack .chart[@metric-loc='Listbox_App Store Quick Links'] li a"
      
      #  Returns a hash of itunes_app_id => array of features.
      #
      #  * <tt>country_name</tt>:: Name of the country to collect featuring for.
      #
      def crawl(country_name)
        urls = [ ITUNES_MAIN_PAGE_URL + ITUNES_IPAD_URL_SUFFIX, ITUNES_MAIN_PAGE_URL + ITUNES_IPHONE_URL_SUFFIX ]
        
        http = Net::HTTP.new("itunes.apple.com", 80)
        headers = ITUNES_UA_HEADERS.merge("X-Apple-Store-Front" => COUNTRY_TO_STORE_FRONTS[ country_name ])
        
        crawled_urls = {}
        result = {}
        
        # while we have the URLs to crawl on stack
        while urls.present?
          # pop an URL
          url, store = store_and_url_from_url(urls.pop)
          
          # check for duplicate visit
          next if crawled_urls[ url_signature(url) ]
          
          puts "Fetching #{ url }..."
          
          body = http.get(url, headers).body
          
          unless body =~ /\<body/
            go_to_url = CGI.unescapeHTML(body.match(/\<string\>(http\:\/\/.+)\<\/string\>/m)[1])
            puts "Just got a plist from #{url} - redirecting ourselves to #{go_to_url}"
            
            crawled_urls[ url_signature(url) ] = true
            urls << url_for_store(go_to_url, store)
            
            next
          end
          
          document = Hpricot(body)
          title = document.search("title").first.to_plain_text
          # mark the URL so that we don't visit it again now
          crawled_urls[ url_signature(url) ] = true
          
          puts "#{url} - #{ title } for #{ store }, still has to fuck through #{ urls.size }"
                    
          page = Featuring::Page::Base.for_uid(store, uid_from_path(url), title)
          
          # iterate over all features
          {Featuring::Feature::Super => SUPER_FEATURING_CSS_PATH, 
           Featuring::Feature::Brick => BRICK_FEATURING_BRICK_CSS_PATH, 
           Featuring::Feature::Item =>  SWOOSH_FEATURING_BRICK_CSS_PATH}.each do |klass, css|
            
            index = -1
            document.search(css).each do |link|
              index += 1

              next unless link["href"].starts_with?("http://")
              
              url = page_path_from_url(link["href"])              
              uid = uid_from_path(url)

              if uid.first == :app
                featuring = klass.find_or_create_by_page_id_and_rank(page.id, index)

                result[ uid.last ] ||= []
                result[ uid.last ] << featuring
              else
                urls << url_for_store(url, store) if (uid.first.present? and crawled_urls[url_signature(url)].blank?)
              end
            end
            
          end
          
          # iterate over quick links
          document.search(QUICK_LINKS_CSS_PATH).each do |link|
            url = page_path_from_url(link["href"])
            uid = uid_from_path(url)
            
            urls << url_for_store(url, store) if (uid.first.present? and uid.first != :app and crawled_urls[url_signature(url)].blank?)
          end
          
          # iterate over all categories
          document.search(CATEGORIES_CSS_PATH).each do |opt|
            url = page_path_from_url(opt["value"])
            uid = uid_from_path(url)

            urls << url_for_store(url, store) if (uid.first.present? and uid.first != :app and crawled_urls[url_signature(url)].blank?)
          end
        end
        
        result
      end
      
    protected
    
      def url_for_store(url, store)
        return url if url.include?("&pillIdentifier=")
        url + (store == :iphone ? ITUNES_IPHONE_URL_SUFFIX : ITUNES_IPAD_URL_SUFFIX) 
      end
      
      def store_and_url_from_url(url)
        store = url.include?(ITUNES_IPHONE_URL_SUFFIX) ? :iphone : :ipad
        [url, store]
      end
      
      def url_signature(url)
        url, store = store_and_url_from_url(url)
        (uid_from_path(url) + [store]).join("_")
      end
    
      #  Extracts path from an URL.
      #
      def page_path_from_url(url)
        ::URI.parse(url).request_uri
      end
      
      #  Extracts an UID (room, grouping or app) from an URL/path.
      #
      def uid_from_path(url)
        return [:main, 0] if url.include?(ITUNES_MAIN_PAGE_URL)

        p url
        
        return [:category, url.match(/viewGenre\?id\=(\d+)/)[1]] if url.include?("viewGenre?id=")
        return [:category, url.match(/viewGrouping\?id\=(\d+)/)[1]] if url.include?("viewGrouping?id=")
        return [:room, url.match(/viewMultiRoom\?fcId\=(\d+)/)[1]] if url.include?("viewMultiRoom?fcId=")
        return [:app, url.match(/.+id(\d+)/)[1]] if url =~ /\/id\d+/
        
        [nil, nil]
      end
      
    end
  
  end
  
end