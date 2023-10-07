require './src/core/event/ChoiceEvent.rb'
require './src/core/event/option/OptionSlider.rb'
require './src/core/event/option/Option.rb'

class CharacterStatsEvent < ChoiceEvent
  attr_accessor :character_values
  def initialize(_event_name)
    super(_event_name)
    @options = [
      OptionSlider.new(
        "Intelligence"
      ),
      OptionSlider.new(
        "Force"
      ),
      OptionSlider.new(
        "Agilite"
      ),
      OptionSlider.new(
        "Chance"
      ),
      Option.new(
        "Suivant"
      )
    ]
    @selected = 0
  end

  def update
    # This is the main boucle of the game
    Displayer.display_event_choice(self)
  end


end