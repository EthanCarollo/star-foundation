class InputManager

  # The function block the input just set the time out of getting the input to 0
  # So in fact, it just catch the input without blocking the program.
  def self.block_input
    Curses.timeout = 0
    Curses.getch
  end

  # This function reset the time out of the input catching so, the function Curses.getch
  # will block the program again.
  def self.unblock_input
    Curses.timeout = -1
  end

  def self.input_event_story(event)
    input = Curses.getch
    case input
      when Curses::KEY_RIGHT, 10
      event.skip_story_event
    end
  end

  def self.input_event_choice(event)
    input = Curses.getch
    case input
    when Curses::KEY_DOWN
      event.selected = (event.selected + 1) % event.options.length
    when Curses::KEY_UP
      event.selected = (event.selected - 1) % event.options.length
    when Curses::KEY_RIGHT, 10
      # Some refactoring is needed here
      if(event.options[event.selected].instance_of?(OptionSlider))
        event.update_slider(event.options[event.selected].option_val_identifier, 1)
      else
        event.options[event.selected].select
      end
    when Curses::KEY_LEFT
      # Some refactoring is needed here
      if(event.options[event.selected].instance_of?(OptionSlider))
        event.update_slider(event.options[event.selected].option_val_identifier, -1)
      else
        event.options[event.selected].select
      end
    end
  end

end