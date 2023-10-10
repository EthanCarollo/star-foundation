require "./src/core/event/ChoiceEvent"
require './src/core/event/option/OptionDice.rb'
require './src/core/Game.rb'

# This Event represent the choice Event so it will be used like it
class DiceChoiceEvent < ChoiceEvent
  attr_accessor :options
  attr_accessor :selected

  def initialize(event_name, event_data = nil)
    super(event_name, event_data)
  end

  def initialize_event_data(event)
    event["choice"].each do |choice|
      @options.push(
        OptionDice.new(choice["text"],
                   lambda { || select_dice_option(choice) },
                   choice)
      )
    end
  end

  def select_dice_option(dice_information)
    Game.instance.play_view.go_dice_event(dice_information)
  end

end