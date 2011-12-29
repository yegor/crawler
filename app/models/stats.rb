class Stats < ActiveRecord::Base
  
  class << self
    
    #  Computes the ranking of a game over time, returning a hash of the structure:
    #   chart_1 => game => { date_1 => rank, date_2 => rank, ... }
    #
    #  * <tt>options</tt>:: Options to use. Keys are :game, :timespan, :charts. Timespan defaults to a week,
    #    charts default to all available charts.
    #
    #
    def raking_over_time(options = {})
      options = { :charts => Chart.all, :games => [], :timespan => (1.week.ago.utc..Time.now.utc) }.merge(options)
      imports = Import.where("created_at >= ? and created_at <= ?", options[:timespan].min, options[:timespan].max).all
      
      results = ChartSnapshot
        .select("game_snapshots.rank as rank, meta_data.game_id as game_id, chart_snapshots.chart_id as chart_id, chart_snapshots.created_at as date")
        .where(:import_id => imports, :chart_id => options[:charts])
        .joins("INNER JOIN game_snapshots ON game_snapshots.chart_snapshot_id = chart_snapshots.id AND game_snapshots.game_id IN ( #{options[:games].map(&:id).map(&:to_i).join(", ") } )")
        .joins("INNER JOIN meta_data ON meta_data.id = game_snapshots.meta_data_id")
    
      charts_by_id = options[:charts].index_by(&:id)
      games_by_id = options[:games].index_by(&:id)
      
      results.each { |result| result.date = result.date.beginning_of_hour }
      results_by_chart_id = results.group_by(&:chart_id)
      
      results_by_chart_id.inject({}) do |memo, (chart_id, ranks)|
        memo.merge(charts_by_id[chart_id] => ranks.group_by(&:game_id).inject({}) do |m, (game_id, rankings)|
          m.merge( games_by_id[game_id] => rankings.index_by(&:date) )
        end)
      end
    end
    
  end
  
end