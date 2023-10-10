
require './src/core/event/option/Option.rb'

class OptionDice < Option
  attr_accessor :option_val_identifier
  attr_accessor :value_needed

  def initialize(text, lambda, option_information)
    super(text, lambda)
    @option_val_identifier = option_information["ability_needed"].downcase
    @value_needed = option_information["dice_needed"]
  end

end