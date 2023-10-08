require './src/core/player/PlayerStats.rb'

class Player
  attr_accessor :stats

  def initialize
    @stats = PlayerStats.new
  end
end