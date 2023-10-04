
require './src/core/event/option/Option.rb'

class OptionSlider < Option
  attr_accessor :option_val_identifier
  attr_accessor :option_val

  def initialize(text)
    super(text, nil)
    @option_val = 0
    @option_val_identifier = text.downcase
  end

  def select(id_to_add)
    @option_val = @option_val + id_to_add
  end

end