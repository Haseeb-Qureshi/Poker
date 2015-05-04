require_relative 'player'

class Computer < Player
  attr_reader :message
  def initialize(game, display)
    super
    @message = "Let's play some poker!"
  end

  def bet(bb)
    @message = "I bet #{bb}."
    super
  end

  def check
    @message = "I check."
    super
  end

  def raise(bb)
    @message = "I raise!"
    super
  end

  def call_bet(bet)
    @message = "I call."
    super
  end

  def fold
    @message = "Whatever. I fold."
    super
  end


end
