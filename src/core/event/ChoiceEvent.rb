require "./src/core/event/Event"

# This Event represent the choice Event so it will be used like it
class ChoiceEvent < Event
  attr_accessor :options
  attr_accessor :selected

  def initialize(event_name, event_data = nil)
    super(event_name, event_data)
    @options = []
  end

  def initialize_event_data(event)
    raise("Need to set up the intitialize function of ChoiceEvent")
  end

  def update
    # This is the main boucle of the game
    Displayer.display_event_choice(self)
  end
end