class GameSnapshot < ActiveRecord::Base
  belongs_to :game
  belongs_to :meta_data
  belongs_to :chart_snapshot
  
  validates_presence_of :rank
  validates_presence_of :game
  validates_presence_of :meta_data
  validates_presence_of :chart_snapshot
  validates_presence_of :itunes_id
  
  # before_validation :set_itunes_id
  
  scope :not_yet_sexy, where(:appstore_syncronized => false)
  
  class << self
    
    def bulk_create(games, metas, entries, chart_snapshot)
      columns = self.new.send(:arel_attributes_values).keys.map(&:name)
      
      sql = "INSERT IGNORE INTO game_snapshots ( #{columns.join ", "} ) VALUES "
      games.each do |game|
        snapshot = self.new(:created_at => Time.now, :updated_at => Time.now, :game_id => game.id, :rank => entries[ game.itunes_id ].rank, :meta_data_id => metas[ game.id ].id, :chart_snapshot_id => chart_snapshot.id)
        
        snapshot.smart_assign_attributes( entries[ game.itunes_id ].instance_values )
        snapshot.smart_assign_attributes( entries[ game.itunes_id ].lookup_entry.instance_values )
        
        vals = [0] + snapshot.send(:arel_attributes_values).values[1..-1]
        sql << "( #{ vals.map { |v| connection.quote(v) }.join ", " } ),"
      end
      
      connection.execute(sql.chop)
      # GameSnapshot.create(:game => game, :meta_data => meta_data, :chart_snapshot => chart_snapshot, :rank => (index + 1)).itunes_id
    end
    
  end
  
  #  Update required attributes with AppStore Lookup entry
  #
  #  * <tt>entry</tt>:: +AppStore::LookupEntry+ lookup entry
  #
  def update_with_entry(entry)
    self.meta_data.smart_update_attributes entry.instance_values.symbolize_keys
    self.smart_update_attributes entry.instance_values.symbolize_keys
  end
  
  private
  
  # def set_itunes_id
  #   self.itunes_id = game.itunes_id
  # end
end
