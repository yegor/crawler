class HomeController < ApplicationController
  
  def index
  end

  def data
    @rankings = Stats.raking_over_time(:game => Game.find(2137), :charts => [Chart.find(113), Chart.find(111), Chart.find(15)])
  end

end
