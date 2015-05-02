require_relative 'card'

class Deck
  SUITS = [:s, :d, :c, :h]

  def initialize
    generate_cards
    shuffle_cards
  end

  def take_one
    @cards.pop
  end

  def cards_left
    @cards.count
  end

  private
  def generate_cards
    @cards = []
    (2..14).each { |rank| SUITS.each { |suit| @cards << Card.new(rank, suit) } }
  end

  def shuffle_cards
    @cards.shuffle!
  end
end
