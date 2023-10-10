require './src/core/event/ChoiceEvent.rb'
require './src/core/event/option/OptionSlider.rb'
require './src/core/event/option/Option.rb'
require './src/core/Game.rb'

class CharacterStatsEvent < ChoiceEvent
  attr_accessor :character_values
  attr_accessor :point_to_set
  def initialize(_event_name, event)
    super(_event_name)
    @options = [
      OptionSlider.new(
        "Intelligence", 10
      ),
      OptionSlider.new(
        "Force", 10
      ),
      OptionSlider.new(
        "Agilite", 10
      ),
      OptionSlider.new(
        "Chance", 10
      ),
      Option.new(
        "Suivant",
        lambda { || finish_personalisation }
      )
    ]
    @point_to_set = 10
    @selected = 0
    @next_event_id = event["next_event_id"]
  end

  def update
    # This is the main boucle of the game
    Displayer.display_event_choice(self)
  end

  def update_slider(slider_identifier, value)
    @options.each do |option|
      if option.instance_of?(OptionSlider) && option.option_val_identifier == slider_identifier
        option.select(value, self)
      end
    end
  end

  def finish_personalisation
    # This is the function called when we select the option to go to the next event
    # so in this function we need to set the player stats with the points attribued
    # to options and go next event rapidly
    if point_to_set <= 0
      @options.each do |option|
        if option.instance_of?(OptionSlider)
          Game.instance.play_view.player.stats.set_stat(option.option_val_identifier, option.option_val)
        end
      end
    end
    # Continue the story with the next event who is 0 in this case
    Game.instance.play_view.go_next_event(@next_event_id)
  end

end