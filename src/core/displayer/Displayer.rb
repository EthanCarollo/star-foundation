
# This class will just display text
class Displayer
  def self.display_progressively_text(text)
    text.chars.each do |char|
      Curses.addch(char)
      Curses.refresh
      sleep(0.05) # Délai en secondes pour l'effet de ralenti
    end
  end

  # This function just diplay a text :(
  def self.display_text(text)
    Curses.clear
    Curses.refresh

    Curses.setpos(Curses.lines / 2, (Curses.cols - text.length) / 2)
    Curses.addstr(text)

  end

  # This function is used for the display of the event with multiple choice (so a ChoiceEvent)
  def self.display_event_choice(event)
    Curses.clear
    Curses.cbreak
    Curses.echo
    # Set the color pair set in the init_color_pair method
    Curses.attron(Curses.color_pair(1) | Curses::A_BOLD)

    Curses.setpos(((Curses.lines) / 2 - event.options.length), (Curses.cols - event.event_name.length) / 2)
    # Set progressively the event name before show the option
    if(event.event_displayed == false)
      Curses.nocbreak
      self.display_progressively_text(event.event_name)
      sleep(1)
      event.event_displayed = true
    end

    Curses.clear
    # Recenter the text after the clear
    Curses.setpos(((Curses.lines) / 2 - event.options.length), (Curses.cols - event.event_name.length) / 2)
    Curses.addstr("#{event.event_name}\n")
    Curses.attroff(Curses.color_pair(1) | Curses::A_BOLD)

    # Show the options
    event.options.each_with_index do |option, index|
      if event.selected == index
        Curses.setpos(((Curses.lines) / 2 +index - event.options.length+1), (Curses.cols - option.get_text.length-4) / 2)
        Curses.attron(Curses.color_pair(2) | Curses::A_BOLD)
        Curses.addstr("=>#{option.get_text}<=\n")
        Curses.attroff(Curses.color_pair(2) | Curses::A_BOLD)
      else
        Curses.setpos(((Curses.lines) / 2 +index - event.options.length+1), (Curses.cols - option.get_text.length) / 2)
        Curses.addstr("#{option.get_text}\n")
      end
    end

    Curses.refresh

    case Curses.getch
      when Curses::KEY_DOWN
        event.selected = (event.selected + 1) % event.options.length
      when Curses::KEY_UP
        event.selected = (event.selected - 1) % event.options.length
      when Curses::KEY_ENTER
        event.options[event.selected].select
    end
    # Take the input of the user
  end

  def self.init_color_pair

    Curses.start_color
    # The pair 1 is for something that is agressive
    Curses.init_pair(1, Curses::COLOR_RED, Curses::COLOR_BLACK)
    # The pair 2 is for the selected text
    Curses.init_pair(2, 248, Curses::COLOR_BLACK)

  end

end