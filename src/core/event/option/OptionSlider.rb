
require './src/core/event/option/Option.rb'

class OptionSlider < Option
  attr_accessor :option_val_identifier
  attr_accessor :option_val
  @max_val # The max value of the Slider
  @min_val # The min value of the Slider

  def initialize(text, maximum)
    super(text, nil)
    @option_val = 0
    @option_val_identifier = text.downcase
    @max_val = maximum
    @min_val = 0
  end

  def select(id_to_add, event)
    if can_add_value(id_to_add) || (event.point_to_set - id_to_add) < 0
      return
    end
    event.point_to_set -= id_to_add
    @option_val += id_to_add
  end

  def can_add_value(val_to_add)
    return (@option_val + val_to_add) > @max_val || (@option_val + val_to_add) < @min_val
  end

end