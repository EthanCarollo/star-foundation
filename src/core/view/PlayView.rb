
require "./src/core/view/View.rb"
require "./src/core/Game.rb"
require "./src/core/player/Player.rb"
require "./src/core/displayer/Displayer.rb"
require "./src/core/event/character_event/CharacterStatsEvent.rb"
require "./src/core/event/ChoiceEvent.rb"
require "./src/core/event/StoryEvent.rb"
require "./src/core/event/dice_event/DiceChoiceEvent.rb"
require "./src/core/event/dice_event/DiceEvent.rb"
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

  def go_next_event(id_event)
    # Add the actual event to history if it exists
    if @actual_event != nil
      @history_events.push(@actual_event)
    end
    # And go next event in that way
    @next_event = DataManager.event_data[id_event]
    case @next_event["event_type"]
      when "story"
        @actual_event = StoryEvent.new(@next_event["text"], @next_event)
      when "choice"
        @actual_event = ChoiceEvent.new(@next_event["text"], @next_event)
      when "story_stats_personalisation"
        @actual_event = CharacterStatsEvent.new(@next_event["text"], @next_event)
      when "dice_game"
        @actual_event = DiceChoiceEvent.new(@next_event["text"], @next_event)
    end
    # Go next event logic here
    DataManager.save_game_data
  end

  def go_dice_event(dice_information)
    @actual_event = DiceEvent.new(dice_information)
  end
end