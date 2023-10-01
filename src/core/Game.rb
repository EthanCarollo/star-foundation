require 'curses'
require 'json'
require "./src/core/view/MenuView.rb"
require "./src/core/view/PlayView.rb"
require "./src/core/data/DataManager.rb"
require "./src/core/displayer/Displayer.rb"

# This is the main class of the game
# The main class of the game just contains options and selected or not
class Game
  @@instance

  @play_view
  @menu_view
  # The actual view called every update ticks
  @actual_view

  @data_manager


  def initialize
    @@instance = self

    @game_is_running = true

    @play_view = PlayView.new
    @menu_view = MenuView.new
    @actual_view = @menu_view

    @data_manager = DataManager.new
  end

  def self.instance
    @@instance
  end

  def start
    Curses.init_screen
    Curses.cbreak
    Curses.noecho
    Curses.stdscr.keypad(true)
    Curses.curs_set(0)

    Displayer.init_color_pair

    Curses.attron(Curses.color_pair(1) | Curses::A_BOLD)
    Displayer.display_progressively_text("Welcome in Star Foundation")
    sleep(1.5)
    Curses.attroff(Curses.color_pair(1) | Curses::A_BOLD)
    while @game_is_running
      update
    end
  end

  def update
    @actual_view.update
  end

  def quit_game
    @game_is_running = false
  end

  def load_game_view
    @actual_view = @play_view
  end

end