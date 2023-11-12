require "./src/core/event/Event"
require "./src/core/Game.rb"

# This Event represent the story Event so it will be used like it
class ItemRewardEvent < Event
  attr_accessor :next_event_id
  attr_accessor :id_item_reward

  def initialize(event_name, event_data = nil)
    super(event_name, event_data)
  end

  def initialize_event_data(event)
    @next_event_id = event["next_event_id"]
    @item_reward = event["item_reward"]
  end

  def update
    Displayer.display_event_story(self)
  end

  def skip_story_event
    Game.instance.play_view.player.items.push(@item_reward)
    Game.instance.play_view.go_next_event(@next_event_id)
  end
end