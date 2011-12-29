class Filter
  attr_accessor :countries, :categories, :game_names, :chart_kinds
  
  def initialize(attributes = {})
    self.attributes = attributes if attributes.present?
  end
  
  def attributes
    %w(countries game_names chart_kinds categories).inject({}) do |result, name|
      result.merge(name => send(name))
    end.with_indifferent_access
  end
  
  def attributes=(values)
    values.each do |name, value|
      send(name.to_s + "=", value)
    end
  end
  
  def games
    MetaData.where(:name => self.game_names).group(:game_id).all.map(&:game)
  end
  
  def charts
    Chart.where(:country => self.countries, :genre => self.categories.map { |g| g == "all" ? nil : g }, :kind => self.chart_kinds)
  end
  
  def split_into_charts
    self.chart_kinds.map do |chart_kind|
      self.class.new(self.attributes.merge(:chart_kinds => [chart_kind]))
    end
  end
  
end