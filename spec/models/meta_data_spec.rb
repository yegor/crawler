# == Schema Information
#
# Table name: meta_data
#
#  id                  :integer(4)      not null, primary key
#  name                :string(255)
#  summary             :text
#  new_version         :boolean(1)      default(FALSE)
#  game_id             :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#  publisher           :string(255)
#  rights              :text
#  release_date        :datetime
#  file_size_bytes     :integer(4)
#  itunes_artwork_url  :string(255)
#  itunes_id           :integer(8)
#  release_notes       :string(255)
#  game_center_enabled :boolean(1)
#  genres              :string(255)
#  screenshots         :string(255)
#  version             :string(255)
#
# Indexes
#
#  index_meta_data_on_game_id    (game_id)
#  index_meta_data_on_itunes_id  (itunes_id)
#

require 'spec_helper'

describe MetaData do
  before(:each) do
    @game = Game.create :itunes_id => 137137, :release_date => Time.now
    
    @attributes = {:name => "Cham Cham", :summary => "The best game ever", :rights => "one1eleven (c)",
      :publisher => "Zynga", :release_date => Time.now, :itunes_id => 137137}
  end
  
  it 'should be able to compare MetaData with each other' do
    @meta_data = MetaData.create @attributes.merge(:game => @game)
    
    @new_meta_data = MetaData.new @attributes
    @meta_data.should == @new_meta_data

    @new_meta_data = MetaData.new @attributes.clone.update(:name => "Angry Birds")
    @meta_data.should_not == @new_meta_data
  
    @new_meta_data = MetaData.new @attributes.clone.update(:summary => "Ya tvoy appstor truba shatal")
    @meta_data.should_not == @new_meta_data

    @new_meta_data = MetaData.new @attributes.clone.update(:release_date => (Time.now + 1.day))
    @meta_data.should_not == @new_meta_data
  end
  
  it 'should create new MetaData object for a new game' do
    @entry = AppStore::ChartEntry.new @attributes
    
    lambda do
      @meta_data = MetaData.find_or_create_from_appstore :game => @game, :entry => @entry
      
      @meta_data.new_version.should be_true
    end.should change(MetaData, :count).by(1)
    
    @meta_data.should_not be_new_record
  end
  
  it 'should track game updates by creating new MetaData objects' do
    @entry = AppStore::ChartEntry.new @attributes
    @meta_data = MetaData.find_or_create_from_appstore :game => @game, :entry => @entry
    
    lambda do
      new_entry = AppStore::ChartEntry.new @attributes.clone.update(:release_date => (Time.now + 2.days))
      @new_meta_data = MetaData.find_or_create_from_appstore :game => @game, :entry => new_entry
      
      @new_meta_data.new_version.should be_true
      @new_meta_data.release_date.should == new_entry.release_date
    end.should change(MetaData, :count).by(1)
    
    @new_meta_data.should_not be_new_record
    @new_meta_data.id.should_not == @meta_data.id
  end
  
  it 'should track metadata changes for any game by creating new MetaData objects' do
    @entry = AppStore::ChartEntry.new @attributes
    @meta_data = MetaData.find_or_create_from_appstore :game => @game, :entry => @entry
    
    lambda do
      new_entry = AppStore::ChartEntry.new @attributes.clone.update(:summary => "Some new summary nahuj")
      @new_meta_data = MetaData.find_or_create_from_appstore :game => @game, :entry => new_entry
      
      @new_meta_data.new_version.should_not be_true
    end.should change(MetaData, :count).by(1)
    
    @new_meta_data.should_not be_new_record
    @new_meta_data.id.should_not == @meta_data.id
  end
  
  it 'should not create new MetaData objects if nothing has changed' do
    
    @entry = AppStore::ChartEntry.new @attributes
    @meta_data = MetaData.find_or_create_from_appstore :game => @game, :entry => @entry
    lambda do
      @new_meta_data = MetaData.find_or_create_from_appstore :game => @game, :entry => @entry
    end.should_not change(MetaData, :count)
    
    @new_meta_data.should_not be_new_record
    @new_meta_data.id.should == @meta_data.id
  end
  
end

