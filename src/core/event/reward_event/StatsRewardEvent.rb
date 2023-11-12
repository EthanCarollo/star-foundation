require "./src/core/event/Event"
require "./src/core/Game.rb"

# This Event represent the story Event so it will be used like it
class StatsRewardEvent < Event
  attr_accessor :next_event_id
  attr_accessor :ability_identifier
  attr_accessor :ab_gain

  def initialize(event_name, event_data = nil)
    super(event_name, event_data)
  end

  def initialize_event_data(event)
    @next_event_id = event["next_event_id"]
    @ability_identifier = event["ability"]
    @ab_gain = event["gain"]
  end

  def update
    Displayer.display_event_story(self)
  end

  def skip_story_event
    Game.instance.play_view.player.stats.incr_stat(@ability_identifier, @ab_gain)
    Game.instance.play_view.go_next_event(@next_event_id)
  end
end