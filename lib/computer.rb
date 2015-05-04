require_relative 'player'

class Computer < Player
  attr_reader :message
  def initialize(game, display)
    super
    @message = "Let's play some poker, asshole."
  end


end
