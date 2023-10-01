require 'json'

class DataManager

  # Data from the game
  @event_data
  @event_type_data

  # On create, load the event data
  def initialize
    load_event_data
  end

  def load_event_data
    file = File.open "./ressources/event_data.json"
    json = JSON.load file
    @event_data = json["events"]
    @event_type_data = json["event_types"]
    print(@event_data)
    print(@event_type_data)
  end
end