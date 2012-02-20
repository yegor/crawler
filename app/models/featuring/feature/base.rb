module Featuring
  
  module Feature
    
    class Base < ActiveRecord::Base
      set_table_name :featurings
      has_and_belongs_to_many :game_snapshots, :foreign_key => :featuring_id, :join_table => :featurings_game_snapshots
    end
    
  end
  
end