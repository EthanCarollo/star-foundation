require './src/core/event/ChoiceEvent.rb'
require './src/core/event/option/Option.rb'
require './src/core/Game.rb'
require './src/core/displayer/Displayer.rb'

# The menu event is the event used to show the menu, in fact, it's just a choice event with presset options
class MenuEvent < ChoiceEvent

  def initialize(_event_name)
    super(_event_name)
    @options = [
      Option.new(
        "Commencer le jeu",
        lambda { || Game.instance.load_game_view }
      ),
      Option.new(
        "Reprendre le jeu"
      ),
      Option.new(
        "Quitter le jeu",
        lambda { || Game.instance.quit_game }
      )
    ]
    @selected = 0
  end

end