class Event
  attr_accessor :event_name
  attr_accessor :event_displayed

  def initialize(_event_name)
    @event_name = _event_name
    @event_displayed = false
  end

  def update

  end
end