module Featuring
  
  module Feature
    
    class Base < ActiveRecord::Base
      set_table_name :featurings
      
      belongs_to :page, :foreign_key => :page_id, :class_name => "Featuring::Page::Base"
      has_and_belongs_to_many :game_snapshots, :foreign_key => :featuring_id, :join_table => :featurings_game_snapshots
    end
    
  end
  
end