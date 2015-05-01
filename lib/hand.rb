class Hand
  include Comparable

  attr_reader :cards

  def initialize(cards = [], deck = nil)
    @cards = cards
    @deck = deck
    @value = 0

    check_hand if @cards.count == 5
  end

  def take_card
    @cards << @deck.take_one
    check_hand if @cards.count == 5
  end

  def discard_card(card_pos)
    raise NoCardError if @cards.delete_at(card_pos).nil?
  end

  def <=>(other_hand)
    case @value <=> other_hand.value
    when 1 return 1
    when -1 return -1
    else
      break_tie_with(other_hand)
    end
  end

  protected
  attr_reader :value

  def values

  private

  def break_tie_with(other_hand)
    case @value
    when 1, 5, 6, 9 then easy_compare(other_hand)
    when 2 then easy_compare
    end
  end

  def easy_compare(other_hand)
    #iterate over each thing, 10**n multiply by value and add together and see whose dick is bigger

  end

  def pair_compare(other_hand)
    our_pair = @cards.map(&:value) - @cards.map(&:value).uniq
    their_pair = other_hand.cards.map(&:value) - other_hand.cards.map(&:value).uniq
    our_pair.first <=> their_pair.first
  end

  def check_hand
    @value = 1 if high_card
    @value = 2 if pair
    @value = 3 if two_pair
    @value = 4 if trips
    @value = 5 if straight
    @value = 6 if flush
    @value = 7 if full_house
    @value = 8 if quads
    @value = 9 if straight_flush
  end

  def high_card
    @cards.map(&:value).uniq.size != 5
  end

  def pair
    @cards.map(&:value).uniq.size == 4
  end

  def two_pair
    @cards.map(&:value).uniq.size == 3
  end

  def trips
    duplicates = @cards.inject(Hash.new(0)) do |counts, card|
      counts[card.value] += 1
      counts
    end
    duplicates.values.max == 3
  end

  def straight
    start = @cards.first.value
    @cards.map(&:value) == (start..start + 4).to_a
  end

  def flush
    @cards.map(&:suit).uniq.size == 1
  end

  def full_house
    @cards.map(&:value).uniq.size == 2
  end

  def quads
    duplicates = @cards.inject(Hash.new(0)) do |counts, card|
      counts[card.value] += 1
      counts
    end
    duplicates.values.max == 4
  end

  def straight_flush
    flush && straight
  end

end

class NoCardError < StandardError
end
