class Hand
  include Comparable

  attr_reader :cards

  def initialize(cards = [], deck = nil)
    @cards = cards
    @deck = deck
    @hand_rank = 0

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
    case hand_rank <=> other_hand.hand_rank
    when 1 return 1
    when -1 return -1
    else
      break_tie_with(other_hand)
    end
  end

  protected
  attr_reader :value, :ranks

  def ranks
    @cards.map(&:value)
  end

  private

  def break_tie_with(other_hand)
    case hand_rank
    when 1, 5, 6, 9 then easy_compare(other_hand)
    when 2, 4, 8 then single_pair_compare(other_hand)
    when 3 then 0 # NOT DONE
    when 7 then 0
    end
  end

  def easy_compare(other_hand)
    val1 = 0
    ranks.each_with_index { |rank, i| val1 += rank * (10 ** i) }

    val2 = 0
    other_hand.ranks.each_with_index { |rank2, j| val2 += rank2 * (10 ** i) }

    val1 <=> val2
  end

  def pair_compare(other_hand)
    our_pairs = ranks - ranks.uniq
    their_pairs = other_hand.ranks - other_hand.ranks.uniq
    our_pairs.sort.first <=> their_pairs.sort.first
  end

  def single_pair_compare(other_hand)
    case pair_compare(other_hand)
    when 1 then 1
    when -1 then -1
    else easy_compare(other_hand)
  end

  def check_hand
    hand_rank = 1 if high_card
    hand_rank = 2 if pair
    hand_rank = 3 if two_pair
    hand_rank = 4 if trips
    hand_rank = 5 if straight
    hand_rank = 6 if flush
    hand_rank = 7 if full_house
    hand_rank = 8 if quads
    hand_rank = 9 if straight_flush
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
