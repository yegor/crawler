module HomeHelper
  
  include AppStore::ChartConfig
  
  KINDS_TO_SHORTCUTS = {"topfreeapplications" => "free", 
                        "toppaidapplications" => "paid", 
                        "topgrossingapplications" => "grossing", 
                        "topfreeipadapplications" => "free iPad", 
                        "toppaidipadapplications" => "paid iPad", 
                        "topgrossingipadapplications" => "grossing iPad"}
  
  
  #  Returns a short but descriptive name of the serie displaying some top.
  #
  #  * <tt>chart</tt>:: +Chart+ to use.
  #
  def series_name(chart, game)
    "#{game.meta_data.name}: #{ COUNTRIES[chart.country] } #{ KINDS_TO_SHORTCUTS[chart.kind] } #{ chart.genre || "apps" }"
  end
  
  #  Returns the title for the top.
  #
  def top_title(snapshot)
    "Top #{ snapshot.chart.country } #{ KINDS_TO_SHORTCUTS[snapshot.chart.kind] } #{ snapshot.chart.genre || "apps" }"
  end
  
  #  Returns shorted country names
  def country_shortcuts
    COUNTRIES
  end
  
  #  Returns chart title to display above a graph.
  #
  #  * <tt>filter</tt>:: Filter record to process.
  #
  def chart_title(filter)
    "Top #{ KINDS_TO_SHORTCUTS[filter.chart_kinds.first] } rankings"
  end
  
  #  Returns filter countries to be used.
  #
  def filter_countries
    SUPER_COUNTRIES
  end
  
  #  Returns available charts to draw.
  #
  def filter_charts
    KINDS_TO_SHORTCUTS
  end
  
  def filter_categories
    %w(all games)
  end
  
  #  Returns options for game select.
  #
  def game_options
    @games.inject({}) do |memo, game|
      memo.merge(game.name => game.id)
    end
  end
  
  #  Returns true if the series shall be hidden by default.
  #
  #  * <tt>chart</tt>:: +Chart+ to use.
  #
  def series_hidden?(chart)
    chart.genre != "games" || chart.kind.include?("ipad")
  end
  
end
