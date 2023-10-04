
require "./src/core/view/View.rb"
require "./src/core/Game.rb"
require "./src/core/player/Player.rb"
require "./src/core/displayer/Displayer.rb"
require "./src/core/event/character_event/CharacterStatsEvent.rb"

class PlayView < View

  @actual_event

  def initialize
    @actual_event = CharacterStatsEvent.new("Choisissez les statistiques de votre personnage.")
  end

  def update
    @actual_event.update
  end

  def go_next_event

  end
end