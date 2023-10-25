
require "./src/core/view/View.rb"
require './src/core/event/option/Option.rb'
require './src/core/event/menu_event/MenuEvent.rb'

class MenuView < View
  @menu_event

  def initialize
    @menu_event = MenuEvent.new("Menu principal")
  end

  def reload_menu
    @menu_event = MenuEvent.new("Menu principal")
  end

  def update
    @menu_event.update
  end

end