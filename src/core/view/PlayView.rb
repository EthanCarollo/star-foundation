
require "./src/core/view/View.rb"
require "./src/core/Game.rb"
require "./src/core/player/Player.rb"
require "./src/core/displayer/Displayer.rb"

class PlayView < View

  def initialize
  end

  def update
    Displayer.display_text("In construction :3")
    Curses.getch
  end

  def go_next_event

  end
end