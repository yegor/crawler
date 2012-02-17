module ChartsHelper

  #  Returns the URL to view a game on itunes.
  def itunes_game_url(game)
    "http://itunes.apple.com/us/app/angry-birds/id#{ game.itunes_id }?mt=8"
  end
  
end
