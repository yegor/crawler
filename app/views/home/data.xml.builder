xml.instruct!

dates = @rankings.values.map(&:keys).flatten.uniq.sort
max = @rankings.values.map { |v| v.values.max }.max + 10
number_of_steps = 10
step = max / 10.0

xml.chart do
  xml.chart_type "line"
  xml.chart_border :top_thickness => 0, :bottom_thickness => 0, :left_thickness => 0, :right_thickness => 0
  xml.chart_pref :line_thickness => 2, :point_size => 5
  xml.chart_rect :x => 30, :y => 30, :width => 800, :height => 500
  
  xml.axis_category :size => 12
  xml.axis_value :size => 12, :min => 1, :max => max, :steps => number_of_steps
  xml.legend :layout => :hide
  
  xml.chart_data do
    xml.row do
      xml.null
      dates.each do |date| 
        xml.string(date.hour == 0 ? date.strftime("%h %d") : date.hour)
      end
    end
    
    @rankings.each do |chart, ranks|
      xml.row do
        xml.string "#{chart.country} - #{chart.kind} of #{chart.genre || "everything"}"
        dates.each do |date|
          xml.number(max - (ranks[date] || 400) + 1)
        end
      end
    end
  end
end