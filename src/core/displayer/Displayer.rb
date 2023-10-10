require "./src/core/input/InputManager.rb"
require './src/core/event/option/OptionSlider.rb'
require './src/core/event/character_event/CharacterStatsEvent.rb'
require './src/core/event/option/Option.rb'
require './src/core/Game.rb'


# This class will just display text
# It will surely need to be cleaned up
class Displayer
  @@color_red
  @@color_white

  # ============ Region 1: Initialization Functions ============
  # These are initialization functions or methods used in the code.

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


  # ============ Region 2: Draw Functions ============
  # These are draw functions or methods used in the code.

  # This function display the text progressively with a end time (this function shouldn't be called in a boucle)
  # The position is the position where we start to write the text
  # text: string
  # color: int (the more time, we will use the static property from the displayer class)
  # x_position: int
  # y_position: int
  def self.display_progressively_text(text, color = 0, y_position = Curses.lines / 2, end_sleep_value = 1, sleep_value = 0.05)
    Curses.attron(Curses.color_pair(color) | Curses::A_BOLD)
    Curses.setpos(y_position, (Curses.cols - text.length) / 2)
    start_y = Curses.stdscr.cury + 0
    text_display = ""
    if sleep_value > 0
      text.chars.each do |char|
        Curses.addstr(char)
        Curses.refresh
        InputManager.block_input
        sleep(sleep_value) # Délai en secondes pour l'effet de ralenti
      end
      sleep(end_sleep_value)
    else
      Curses.addstr(text)
    end
    Curses.attroff(Curses.color_pair(color) | Curses::A_BOLD)
    InputManager.block_input
  end

  def self.display_progressively_cutted_text(cutted_text, color, y_start_position, end_sleep_value = 1, sleep_value = 0.05)
    for i in 0...cutted_text.length
      self.display_progressively_text(cutted_text[i], color, y_start_position+i, end_sleep_value, sleep_value)
    end
  end

  # This function display the text progressively with a end time (this function shouldn't be called in a boucle)
  # The position is the position where we start to write the text
  # text: string
  # color: int (the more time, we will use the static property from the displayer class)
  # x_position: int
  # y_position: int
  def self.display_progressively_text_reverse(text, color = 0, y_position = Curses.lines / 2, x_position = (Curses.cols - text.length) / 2, end_sleep_value = 1)
    Curses.attron(Curses.color_pair(color) | Curses::A_BOLD)
    Curses.setpos(y_position, x_position)
    text.chars.reverse.each do |char|
      Curses.insch(char)
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
  def self.display_text(text, color=0, y_position = Curses.lines / 2, end_sleep = 0, sleep = 0)
    # Cut the text in multiple part
    ct_text = self.cut_text_on_size(text)
    self.display_progressively_cutted_text(ct_text, color, y_position, end_sleep, sleep)
  end

  def self.display_cutted_text(text, color=0, y_position = Curses.lines / 2, end_sleep = 0, sleep = 0)
    # Cut the text in multiple part
    ct_text = self.cut_text_on_size(text)
    self.display_progressively_cutted_text(ct_text, color, y_position, end_sleep, sleep)
  end


  # ============ Region 3: Helper Functions ============
  # These are helper functions or methods used in the code.

  def self.cut_text_on_size(text)
    # Cut the text in multiple parts and create an array, in this case, we can have a good Text presentation
    # In this function, i have the final array and the potential word to test
    new_texts = [""]
    potential_word = ""
    for i in 0...text.length
      char = text[i]

      # Check for the line break character
      if char =~ /\n/
        new_texts[new_texts.length - 1] += potential_word
        potential_word = ""
        new_texts.push("")
        next
      end

      # If the actual string in the array is superior to the width of the Window, then, we create another
      if (potential_word.length + new_texts[new_texts.length - 1].length) > Curses.cols
        new_texts[new_texts.length - 1].slice!(-1)
        new_texts.push("")
      end
      potential_word += char
      if char == " "
        new_texts[new_texts.length - 1] += potential_word
        potential_word = ""
      end
    end
    new_texts[new_texts.length - 1] += potential_word
    return  new_texts
  end


  # ============ Region 4: Event Functions ============
  # These are events functions or methods used in the code called on every frames by events.

  # This function is used by the StoryEvent to display it
  def self.display_event_story(event)
    Curses.clear
    Curses.cbreak
    Curses.noecho
    self.display_event(event)
    InputManager.unblock_input
    InputManager.input_event_story(event)
  end

  def self.display_event_dice(event)
    Curses.clear
    Curses.cbreak
    Curses.noecho

    self.display_event(event)

    y_position_event = Curses.lines / 2 + 2

    if event.dice_launched == false
      for i in 0...30
        self.display_text("Résultat : " + event.get_dice_value.to_s, @color_red, y_position_event)
        sleep(0.05)
      end
      event.dice_launched = true
      event.result = event.get_dice_value
    end

    self.display_text("Résultat : " + event.result.to_s, @color_red, y_position_event)

    InputManager.unblock_input
    InputManager.input_event_dice(event)
  end

  def self.display_event(event)
    y_position_event = (Curses.lines) / 2 - 2

    # Launce once the text progressively
    if event.event_displayed == false
      self.display_cutted_text(event.event_name, @color_red, y_position_event, 0, 0.05)
      event.event_displayed = true
      Curses.clear
    end

    self.display_cutted_text(event.event_name, @color_red, y_position_event)
  end


  # This function is used for the display of the event with multiple choice (so a ChoiceEvent)
  def self.display_event_choice(event)
    Curses.clear
    Curses.cbreak
    Curses.noecho


    y_position_event_name = (Curses.lines) / 2 - event.options.length

    # Launce once the text progressively
    if event.event_displayed == false
      self.display_cutted_text(event.event_name, @color_red, y_position_event_name, 1, 0.05)
      event.event_displayed = true
    end

    Curses.clear
    # Display the the point_to_set text of the event if it is a character stats event
    if event.instance_of?(CharacterStatsEvent)
      point_to_set_text = "Il vous reste #{event.point_to_set} points à attribuer"
      x_position_event_point = (Curses.cols - point_to_set_text.length) / 2
      display_text(point_to_set_text, @color_red, y_position_event_name-1)
    end
    # Display normally the text at the same position
    self.display_cutted_text(event.event_name, @color_red, y_position_event_name)

    # Show the options
    self.display_options(event)

    InputManager.unblock_input
    Curses.refresh

    # Take the input of the user, i think this will go in the InputManager soon
    InputManager.input_event_choice(event)
  end


  # This option is set to just display the options
  def self.display_options(event)
    # Check size of the cut text length
    cut_text_length = cut_text_on_size(event.event_name).length-1

    event.options.each_with_index do |option, index|
      option_val_text = ""
      # Creating a slider if it is an OptionSlider
      if option.instance_of?(OptionSlider)
        option_value = option.option_val
        option_val_text = option.option_val.to_s + " ["
        for i in 1..option_value
          option_val_text += "="
        end
        option_val_text += "] "
      end

      option_text = option_val_text+option.get_text

      if option.instance_of?(OptionDice)
        option_text += " (#{option.option_val_identifier} : #{option.value_needed} | actuel : #{Game.instance.play_view.player.stats.get_stat(option.option_val_identifier)})"
      end

      y_position_option = (Curses.lines) / 2 + index - event.options.length + 2 + cut_text_length

      if event.selected == index
        Curses.attron(Curses.color_pair(2) | Curses::A_BOLD)
        if option.instance_of?(OptionSlider)
          # Display option slider
          option_text = "=> "+option_text
          self.display_text(option_text, @color_white, y_position_option)
        else
          # Display option
          option_text = "=>"+option_text+"<="
          self.display_text(option_text, @color_white, y_position_option)
        end
        Curses.attroff(Curses.color_pair(2) | Curses::A_BOLD)
      else
        self.display_text(option_text, @color_white, y_position_option)
      end
    end

  end


  # ============ End of Regions ============

end