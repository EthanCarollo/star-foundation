class Option
  @option_text
  @setted_func

  def initialize(text, lambda = nil)
    @option_text = text
    @setted_func = lambda
  end

  def get_text
    return @option_text
  end

  def select
    if @setted_func != nil
      @setted_func.call
    else
      raise("the lambda function of an option isn't set")
    end
  end
end