require 'json'
require 'nokogiri'
require './src/core/Game.rb'
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

  # ============ Region 1: Save Functions ============
  # These are events functions who save the actual state of the game

  def self.save_game_data
    doc = Nokogiri::XML(File.open('./resources/save_data.xml'))
    save_player_stats(doc)
    save_history_events(doc)

    # Enregistrer le document XML mis à jour dans un fichier
    File.open('./resources/player_save_data.xml', 'w') do |file|
      file.puts(doc.to_xml)
    end
  end

  # Save the player stats in the xml doc
  def self.save_player_stats(doc)
    # The player save stats function
    stats = doc.css("stats/stat")

    # Go in every stat of the save and save them from the player stats
    stats.each do |stat|
      stat.at('value').content = Game.instance.play_view.player.stats.get_stat(stat.at('name').content)
    end
  end

  def self.save_history_events(doc)

    # Accéder à l'élément où vous souhaitez enregistrer la valeur
    events_xml = doc.at('events/events_history')
    actual_event_xml = doc.at('events/current_event')

    back_event = Game.instance.play_view.history_events

    for i in 0..back_event.length
      event = back_event[i]
      if event == nil
        next
      end

      events_xml << get_xml_node_event(doc,event)

    end
    if Game.instance.play_view.actual_event != nil
      actual_event_xml.set_attribute('id', Game.instance.play_view.actual_event.instance_variable_get("@event_id"))
    end
  end

  def self.get_xml_node_event(doc, event)
    new_event = Nokogiri::XML::Node.new('event', doc)

    # Create name var
    name_event = Nokogiri::XML::Node.new('id', doc)
    name_event.content = event.instance_variable_get("@event_id")
    new_event << name_event

    return new_event
  end

  # ============ Region 2: Load Functions ============
  # These are events functions who load the state of the game from "player_save_data.xml"

  def self.load_save(play_view)
    doc = Nokogiri::XML(File.open('./resources/player_save_data.xml'))
    play_view.go_next_event(doc.at('events/current_event')["id"].to_i)
    load_player_stats(doc)
  end

  def self.load_player_stats(doc)
    stats = doc.css("stats/stat")

    # Set every variables possible in the player stats
    stats.each do |stat|
      Game.instance.play_view.player.stats.instance_variable_set("@#{stat.at('name').content}", stat.at('value').content)
    end
  end

end