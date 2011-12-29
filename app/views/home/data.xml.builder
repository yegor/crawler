dates = @rankings.values.map(&:keys).flatten.uniq.sort
max = @rankings.values.map { |v| v.values.map(&:rank).max }.max

xml.instruct!
xml.chart :caption => "Rankings over time",
          :showLegend => true,
          :legendPosition => :right,
          :yAxisMaxValue => [max.to_i, 15].max,
          :yAxisMinValue => 1,
          :showBorder => 0,
          :bgColor => "FFFFFF",
          :xAxisName => 'Date' do
   
  xml.categories do
    dates.each do |date|
      xml.category :label => (date.hour == 0 ? date.strftime("%h %d") : date.hour)
    end
  end
   
  @rankings.each do |chart, ranks|
    xml.dataset :seriesName => series_name(chart) do
      dates.each do |date|
        xml.set :value => (ranks[date].try(:rank) || 400), :showValue => 0
      end
    end
  end
  
  xml.trendlines do
    xml.line :startValue => 1, :endValue => 10, :displayValue => 'Top 10', :color => "009900", :alpha => 10, :isTrendZone => 1
    xml.line :startValue => 10, :endValue => 25, :displayValue => 'Top 25', :color => "3399CC", :alpha => 10, :isTrendZone => 1
    xml.line :startValue => 25, :endValue => 100, :displayValue => 'Top 100', :color => "FF9900", :alpha => 10, :isTrendZone => 1
  end
            
end