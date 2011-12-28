dates = @rankings.values.map(&:keys).flatten.uniq.sort
max = @rankings.values.map { |v| v.values.max }.max + 10

xml.instruct!
xml.chart :caption => 'App Store rankings over time',
          :showLegend => true,
          :legendPosition => :right,
          :xAxisName => 'Date' do
   
  xml.categories do
    dates.each do |date|
      xml.category :label => (date.hour == 0 ? date.strftime("%h %d") : date.hour)
    end
  end
   
  @rankings.each do |chart, ranks|
    xml.dataset :seriesName => "#{chart.kind} in #{chart.country}", :color => "#ff0000" do
      dates.each do |date|
        xml.set :value => (ranks[date].try(:rank) || 400)
      end
    end
  end
            
end