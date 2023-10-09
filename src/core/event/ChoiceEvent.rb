require "./src/core/event/Event"
require './src/core/event/option/Option.rb'

# This Event represent the choice Event so it will be used like it
class ChoiceEvent < Event
  attr_accessor :options
  attr_accessor :selected

  def initialize(event_name, event_data = nil)
    @selected = 0
    @options = []
    super(event_name, event_data)
  end

  def initialize_event_data(event)
    event["choice"].each do |choice|
      @options.push(
        Option.new(choice["text"],
                   lambda { || Game.instance.play_view.go_next_event(choice["next_event_id"]) })
      )
    end
    # raise("Need to set up the intitialize function of ChoiceEvent")
  end

  def update
    # This is the main boucle of the game
    Displayer.display_event_choice(self)
  end
end