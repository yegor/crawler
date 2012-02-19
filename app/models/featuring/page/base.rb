module Featuring
  
  module Page
    
    class Base < ActiveRecord::Base
      set_table_name :pages
      
      class << self
        
        #  Finds or creates a page being given its uid (as array of two elements) and title.
        #
        def for_uid(store, uid, title)
          klass = {:main => Featuring::Page::Main, :room => Featuring::Page::Room, :category => Featuring::Page::Category}[ uid.first ]
          klass.find_or_create_by_store_and_uid(store, uid.join, :title => title)
        end
      
      end
      
    end
    
  end
  
end