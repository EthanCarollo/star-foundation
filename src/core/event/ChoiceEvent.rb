require "./src/core/event/Event"

class ChoiceEvent < Event
  attr_accessor :options
  attr_accessor :selected

  def initialize(event_name)
    super(event_name)
  end

  def update
    # This is the main boucle of the game
    Displayer.display_event_choice(self)
  end
end