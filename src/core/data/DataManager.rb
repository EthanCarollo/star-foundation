require 'json'

class DataManager

  # Data from the game
  @@event_data

  def self.event_data
    @@event_data
  end

  # On create, load the event data
  def self.init_data
    load_event_data
  end

  def self.load_event_data
    file = File.open "./resources/history_data.json"
    json = JSON.load file
    @@event_data = json["events"]
  end
end