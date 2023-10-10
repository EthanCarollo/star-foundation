require "./src/core/event/Event"

# This Event represent the choice Event so it will be used like it
class DiceEvent < Event
  attr_accessor :dice_launched
  attr_accessor :result
  attr_accessor :val_needed
  @ability_needed
  attr_accessor :win_event_id
  attr_accessor :loose_event_id

  def initialize(dice_selected)
    @dice_launched = false
    @ability_needed = dice_selected["ability_needed"]
    @val_needed = dice_selected["dice_needed"]
    @loose_event_id = dice_selected["lose_event_id"]
    @win_event_id = dice_selected["next_event_id"]

    event_name = dice_selected["long_text"]
    super(event_name, nil)
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
    Displayer.display_event_dice(self)
  end

  def get_dice_value
    # Define the range of numbers
    min_value = Game.instance.play_view.player.stats.get_stat(@ability_needed)
    max_value = 6

    # Generate a random number between min_value and max_value
    random_number = rand(min_value..max_value)
    return random_number
  end
end