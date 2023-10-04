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

end