require "./src/core/event/Event"
require "./src/core/Game.rb"
# HERE I NEED TO CHANGE THE CODE ZEBI
# This Event represent the story Event so it will be used like it
class EndEvent < Event

  def initialize(event_name, event_data = nil)
    super(event_name, event_data)
  end

  def initialize_event_data(event)

  end

  def update
    Displayer.display_event_story(self)
  end

  def skip_story_event
    Game.instance.play_view.end_game
  end
end