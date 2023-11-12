
require "./src/core/view/View.rb"
require "./src/core/Game.rb"
require "./src/core/player/Player.rb"
require "./src/core/displayer/Displayer.rb"
require "./src/core/event/ChoiceEvent.rb"
require "./src/core/event/StoryEvent.rb"
require "./src/core/event/EndEvent.rb"
require "./src/core/event/reward_event/StatsRewardEvent.rb"
require "./src/core/event/reward_event/ItemRewardEvent.rb"
require "./src/core/event/item_event/ItemStoryEvent.rb"
require "./src/core/event/dice_event/DiceChoiceEvent.rb"
require "./src/core/event/dice_event/DiceEvent.rb"
require "./src/core/event/character_event/CharacterStatsEvent.rb"
require "./src/core/data/DataManager.rb"

class PlayView < View

  attr_accessor :actual_event
  attr_accessor :player
  attr_accessor :history_events

  def initialize
    @player = Player.new
    @actual_event = nil
    @history_events = []
  end

  def initialize_view
    go_next_event(0)
  end

  def initialize_save
    DataManager.load_save(self)
  end

  def update
    @actual_event.update
  end

  def go_next_event(id_event, in_history = true)

    # Add the actual event to history if it exists
    if @actual_event != nil && @actual_event.event_id != nil && in_history == true
      @history_events.push(@actual_event)
    end

    # And go next event in that way
    @actual_event = get_event(id_event)

    # Go next event logic here
    DataManager.save_game_data
  end

  def get_event(id_event)
    @event = DataManager.get_event_by_id(id_event)
    @event_obj_to_return = nil
    case @event["event_type"]
    when "story"
      @event_obj_to_return = StoryEvent.new(@event["text"], @event)
    when "choice"
      @event_obj_to_return = ChoiceEvent.new(@event["text"], @event)
    when "item_story"
      @event_obj_to_return = ItemStoryEvent.new(@event["text"], @event)
    when "reward_ability"
      @event_obj_to_return = StatsRewardEvent.new(@event["text"], @event)
    when "reward_item"
      @event_obj_to_return = ItemRewardEvent.new(@event["text"], @event)
    when "story_stats_personalisation"
      @event_obj_to_return = CharacterStatsEvent.new(@event["text"], @event)
    when "dice_game"
      @event_obj_to_return = DiceChoiceEvent.new(@event["text"], @event)
    when "end_game"
      @event_obj_to_return = EndEvent.new(@event["text"], @event)
    end
    return @event_obj_to_return
  end

  def go_dice_event(dice_information)
    @history_events.push(@actual_event)
    @actual_event = DiceEvent.new(dice_information)
  end

  def history_events
    @history_events
  end

  def end_game
    Game.instance.load_menu_view
    # End game logics
  end
end