class Player
  attr_accessor :bankroll, :current_bet

  def initialize(game, display)
    @bankroll = 1000
    @game = game
    @display = display
    @current_bet = 0
  end

  def take_new_hand(deck)
    @hand = Hand.new([], deck)
    5.times { @hand.take_card }
  end

  def cards
    @hand.cards
  end

  def bust?
    @bankroll == 0
  end

  def bet(bb)
    raise BankrollError if bb > bankroll
    @bankroll -= bb
    @current_bet = bb
  end

  def check
  end

  def raise(bb)
    raise BankrollError if 2 * bb > bankroll
    @bankroll -= 2 * bb
    @current_bet = 2 * bb
  end

  def call_bet(bet)
    raise BankrollError if bb > bankroll
    @bankroll -= bb
    @current_bet = 0
  end

  def fold
    @hand = []
    @current_bet = 0
  end

end

class BankrollError < StandardError
end
