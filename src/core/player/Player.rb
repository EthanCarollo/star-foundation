require './src/core/player/PlayerStats.rb'

class Player
  attr_accessor :stats
  attr_accessor :items

  def initialize
    @stats = PlayerStats.new
    @items = []
  end
end