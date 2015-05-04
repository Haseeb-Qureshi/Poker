class Player
  attr_reader :bankroll
  CURSOR_MOVEMENT = {
    "\e[A" => [-1, 0],
    "\e[B" => [1, 0],
    "\e[C" => [0, 1],
    "\e[D" => [0, -1],
    "\r"   => [0, 0],
  }

  def initialize(game, display)
    @bankroll = 1000
    @game = game
    @display = display
  end

  def new_hand(deck)
    @hand = Hand.new([], deck)
    5.times { @hand.take_card }
  end

  def cards
    @hand.cards
  end

  def bust?
    @bankroll == 0
  end

  def call_bet(bet)
  end

  def raise(bet)
  end

  def fold
  end


end
