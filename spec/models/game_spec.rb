# == Schema Information
#
# Table name: games
#
#  id           :integer(4)      not null, primary key
#  release_date :datetime
#  created_at   :datetime
#  updated_at   :datetime
#  itunes_id    :integer(8)
#
# Indexes
#
#  index_games_on_itunes_id  (itunes_id)
#

require 'spec_helper'

describe Game do
  before(:each) do
    @attributes = {:name => "Cham Cham", :summary => "The best game ever", :rights => "one1eleven (c)",
      :publisher => "Zynga", :price => 0.99, :screenshot_url => "http://t3.gstatic.com/images?q=tbn:ANd9GcRGQAt5OuTxLg-1MXQ_ezgZXEspmSw6mnMqgOjd30H4hTn1R0380A",
      :icon_url => "http://t3.gstatic.com/images?q=tbn:ANd9GcRGQAt5OuTxLg-1MXQ_ezgZXEspmSw6mnMqgOjd30H4hTn1R0380A", :release_date => Time.now, :itunes_id => 137137}
      
    @entry = AppStore::ChartEntry.new @attributes
  end
  
  it "should create a new game for a new appstore entry" do
    lambda do
      @game = Game.find_or_create_from_appstore :entry => @entry
    end.should change(Game, :count).by(1)
    
    @game.should_not be_new_record
  end
  
  it "should not create a game which is already present in the system" do
    @game = Game.find_or_create_from_appstore :entry => @entry
    
    lambda do
      @new_game = Game.find_or_create_from_appstore :entry => @entry
    end.should_not change(Game, :count)
    
    @game.id.should == @new_game.id
  end
  
end
