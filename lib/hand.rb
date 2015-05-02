require 'byebug'

class Hand
  include Comparable

  attr_reader :cards, :hand_rank, :ranks

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
    when 1 then 1
    when -1 then -1
    else break_tie_with(other_hand)
    end
  end

  def ranks
    @cards.map(&:value)
  end

  private

  def check_hand
    @hand_rank = 1 if high_card
    @hand_rank = 2 if pair
    @hand_rank = 3 if two_pair
    @hand_rank = 4 if trips
    @hand_rank = 5 if straight
    @hand_rank = 6 if flush
    @hand_rank = 7 if full_house
    @hand_rank = 8 if quads
    @hand_rank = 9 if straight_flush
  end

  def high_card
    ranks.uniq.size == 5
  end

  def pair
    ranks.uniq.size == 4
  end

  def two_pair
    ranks.uniq.size == 3
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
    ranks == (start..start + 4).to_a
  end

  def flush
    @cards.map(&:suit).uniq.size == 1
  end

  def full_house
    ranks.uniq.size == 2
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

  #TIE_BREAKING

  def break_tie_with(other_hand)
    case @hand_rank
    when 1, 5, 6, 9 then easy_compare(other_hand)
    when 2, 4, 8 then single_pair_compare(other_hand)
    when 3, 7 then two_pair_compare(other_hand)
    end
  end

  def easy_compare(other_hand)
    val1 = 0
    ranks.sort.each_with_index { |rank, i| val1 += rank * (10 ** i) }

    val2 = 0
    other_hand.ranks.sort.each_with_index { |rank2, j| val2 += rank2 * (10 ** j) }

    val1 <=> val2
  end

  def pair_compare(other_hand)
    our_pair = ranks.detect { |rank| ranks.count(rank) > 1 }
    their_pair = other_hand.ranks.detect { |rank| ranks.count(rank) > 1 }
    our_pair <=> their_pair
  end

  def single_pair_compare(other_hand)
    case pair_compare(other_hand)
    when 1 then 1
    when -1 then -1
    else easy_compare(other_hand)
    end
  end

  def two_pair_compare(other_hand)
    our_pairs = ranks.select { |rank| ranks.count(rank) > 1 }.sort
    their_pairs = other_hand.ranks.select do |rank|
      other_hand.ranks.count(rank) > 1
    end.sort

    case our_pairs.last <=> their_pairs.last
    when 1 then 1
    when -1 then -1
    else
      case our_pairs.first <=> their_pairs.first
      when 1 then 1
      when -1 then -1
      else
        ranks - our_pairs <=> other_hand.ranks - their_pairs
      end
    end
  end

end

class NoCardError < StandardError
end
