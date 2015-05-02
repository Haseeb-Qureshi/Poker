require_relative 'card'

class Deck

  SUITS = [:s, :d, :c, :h]

  def initialize
    @cards = []
    generate_cards!
    @cards.shuffle!
  end

  def take_one
    @cards.pop
  end

  def cards_left
    @cards.count
  end

  private
  def generate_cards!
    (2..14).each { |val| SUITS.each { |suit| @cards << Card.new(val, suit) } }
  end
end
