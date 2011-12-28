dates = @rankings.values.map(&:keys).flatten.uniq.sort
max = @rankings.values.map { |v| v.values.map(&:rank).max }.max

xml.instruct!
xml.chart :caption => 'App Store rankings over time',
          :showLegend => true,
          :legendPosition => :right,
          :yAxisMaxValue => [max, 15].max,
          :yAxisMinValue => 1,
          :xAxisName => 'Date' do
   
  xml.categories do
    dates.each do |date|
      xml.category :label => (date.hour == 0 ? date.strftime("%h %d") : date.hour)
    end
  end
   
  @rankings.each do |chart, ranks|
    xml.dataset :seriesName => series_name(chart) do
      dates.each do |date|
        xml.set :value => (ranks[date].try(:rank) || 400)
      end
    end
  end
  
  xml.trendlines do
    xml.line :startValue => 10, :displayValue => 'Top 10', :showOnTop => 1
    xml.line :startValue => 25, :displayValue => 'Top 25', :showOnTop => 1
    xml.line :startValue => 100, :displayValue => 'Top 100', :showOnTop => 1
  end
            
end