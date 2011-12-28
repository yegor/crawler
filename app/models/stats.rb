class Stats < ActiveRecord::Base
  
  class << self
    
    #  Computes the ranking of a game over time, returning a hash of the structure:
    #   chart_1 => { date_1 => rank, date_2 => rank, ... }
    #
    #  * <tt>options</tt>:: Options to use. Keys are :game, :timespan, :charts. Timespan defaults to a week,
    #    charts default to all available charts.
    #
    #
    def raking_over_time(options = {})
      options = { :charts => Chart.all, :timespan => (1.week.ago.utc..Time.now.utc) }.merge(options)
      imports = Import.where("created_at >= ? and created_at <= ?", options[:timespan].min, options[:timespan].max).all
      
      results = ChartSnapshot
        .select("game_snapshots.rank as rank, chart_snapshots.chart_id as chart_id, chart_snapshots.created_at as date")
        .where(:import_id => imports, :chart_id => options[:charts])
        .joins("INNER JOIN game_snapshots ON game_snapshots.chart_snapshot_id = chart_snapshots.id AND game_snapshots.game_id = #{options[:game].id}")
    
      charts_by_id = options[:charts].index_by(&:id)
      results_by_chart_id = results.group_by(&:chart_id)
      
      results_by_chart_id.inject({}) do |memo, (chart_id, ranks)|
        rankings = ranks.inject({}) { |memo, chart_rank| memo.merge(chart_rank.date.beginning_of_hour => chart_rank) }
        memo.merge(charts_by_id[chart_id] => rankings)
      end
    end
    
  end
  
end