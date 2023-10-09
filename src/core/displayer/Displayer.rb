require "./src/core/input/InputManager.rb"
require './src/core/event/option/OptionSlider.rb'
require './src/core/event/character_event/CharacterStatsEvent.rb'
require './src/core/event/option/Option.rb'


# This class will just display text
# It will surely need to be cleaned up
class Displayer
  @@color_red
  @@color_white

  # This function display the text progressively with a end time (this function shouldn't be called in a boucle)
  # The position is the position where we start to write the text
  # text: string
  # color: int (the more time, we will use the static property from the displayer class)
  # x_position: int
  # y_position: int
  def self.display_progressively_text(text, color = 0, y_position = Curses.lines / 2, x_position = (Curses.cols - text.length) / 2, end_sleep_value = 1)
    Curses.attron(Curses.color_pair(color) | Curses::A_BOLD)
    Curses.setpos(y_position, x_position)
    text.chars.each do |char|
      Curses.addch(char)
      Curses.refresh
      InputManager.block_input
      sleep(0.05) # Délai en secondes pour l'effet de ralenti
    end
    sleep(end_sleep_value)
    Curses.attroff(Curses.color_pair(color) | Curses::A_BOLD)
    InputManager.block_input
  end


  # This function will just display a text :( (this function can be called in a boucle)
  # The position is the position where we start to write the text
  # text: string
  # color: int (the more time, we will use the static property from the displayer class)
  # x_position: int
  # y_position: int
  def self.display_text(text, color=0, x_position = Curses.lines / 2, y_position = (Curses.cols - text.length) / 2)
    Curses.attron(Curses.color_pair(color) | Curses::A_BOLD)
    Curses.setpos(x_position, y_position)
    Curses.addstr(text)
    Curses.attroff(Curses.color_pair(color) | Curses::A_BOLD)
  end


  def self.display_event_story(event)
    Curses.clear
    Curses.cbreak
    Curses.noecho


    y_position_event_name = (Curses.lines) / 2
    x_position_event_name = (Curses.cols - event.event_name.length) / 2

    # Launce once the text progressively
    if(event.event_displayed == false)
      self.display_progressively_text(event.event_name, @color_red, y_position_event_name, x_position_event_name)
      event.event_displayed = true
    end

    Curses.clear

    display_text(event.event_name, @color_red, y_position_event_name, x_position_event_name)

    InputManager.unblock_input
    InputManager.input_event_story(event)
  end


  # This function is used for the display of the event with multiple choice (so a ChoiceEvent)
  def self.display_event_choice(event)
    Curses.clear
    Curses.cbreak
    Curses.noecho


    y_position_event_name = (Curses.lines) / 2 - event.options.length
    x_position_event_name = (Curses.cols - event.event_name.length) / 2

    # Launce once the text progressively
    if(event.event_displayed == false)
      self.display_progressively_text(event.event_name, @color_red, y_position_event_name, x_position_event_name)
      event.event_displayed = true
    end

    Curses.clear
    # Display the the point_to_set text of the event if it is a character stats event
    if event.instance_of?(CharacterStatsEvent)
      point_to_set_text = "Il vous reste #{event.point_to_set} points à attribuer"
      x_position_event_point = (Curses.cols - point_to_set_text.length) / 2
      display_text(point_to_set_text, @color_red, y_position_event_name-1, x_position_event_point)
    end
    # Display normally the text at the same position
    display_text(event.event_name, @color_red, y_position_event_name, x_position_event_name)

    # Show the options
    self.display_options(event)

    InputManager.unblock_input
    Curses.refresh

    # Take the input of the user, i think this will go in the InputManager soon
    InputManager.input_event_choice(event)
  end


  # This option is set to just display the options
  def self.display_options(event)
    event.options.each_with_index do |option, index|
      option_val_text = ""
      if option.instance_of?(OptionSlider)
        option_value = option.option_val
        option_val_text = option.option_val.to_s + " ["
        for i in 1..option_value
          option_val_text += "="
        end
        option_val_text += "] "
      end
      option_text = option_val_text+option.get_text

      if event.selected == index
        Curses.attron(Curses.color_pair(2) | Curses::A_BOLD)
        if option.instance_of?(OptionSlider)
          # Display option slider
          option_text = "=> "+option_text
          x_position_option = (Curses.lines) / 2 + index - event.options.length + 2
          y_position_option = (Curses.cols - option_text.length-3) / 2
          self.display_text(option_text, @color_white, x_position_option, y_position_option)
        else
          # Display option
          option_text = "=>"+option_text+"<="
          x_position_option = (Curses.lines) / 2 + index - event.options.length + 2
          y_position_option = (Curses.cols - option_text.length) / 2
          self.display_text(option_text, @color_white, x_position_option, y_position_option)
        end
        Curses.attroff(Curses.color_pair(2) | Curses::A_BOLD)
      else
        x_position_option = (Curses.lines) / 2 + index - event.options.length + 2
        y_position_option = (Curses.cols - option_text.length) / 2
        self.display_text(option_text, @color_white, x_position_option, y_position_option)
      end
    end

  end


  # This function will initialize the pair of color
  def self.init_color_pair
    @color_red = 1
    @color_white = 2
    Curses.start_color
    # The pair 1 is for something that is agressive
    Curses.init_pair(@color_red, Curses::COLOR_RED, Curses::COLOR_BLACK)
    # The pair 2 is for the selected text
    Curses.init_pair(@color_white, 248, Curses::COLOR_BLACK)
  end

end