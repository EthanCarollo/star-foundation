require './src/core/player/PlayerStats.rb'

class Player
  @stats

  def initialize
    @stats = PlayerStats.new
  end
end