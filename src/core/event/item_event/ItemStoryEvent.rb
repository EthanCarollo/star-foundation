require "./src/core/event/Event"
require "./src/core/Game.rb"

# This Event represent the story Event so it will be used like it
class ItemStoryEvent < Event
  attr_accessor :next_event_id
  attr_accessor :skip_event_id
  attr_accessor :item_needed

  def initialize(event_name, event_data = nil)
    super(event_name, event_data)
  end

  def initialize_event_data(event)
    @item_needed = event["item_needed"]
    if Game.instance.play_view.player.items.include? @item_needed
      @next_event_id = event["next_event_id_if_item"]
    else
      @skip_event_id = event["next_event_id"]
    end
  end

  def update
    if @next_event_id
      Displayer.display_event_story(self)
    else
      Game.instance.play_view.go_next_event(@skip_event_id, false)
    end
  end

  def skip_story_event
    for i in 0...Game.instance.play_view.player.items
      item = Game.instance.play_view.player.items[i]
      if i == @item_needed
        Game.instance.play_view.player.items.delete_at(i)
      end
    end
    Game.instance.play_view.go_next_event(@next_event_id)
  end
end