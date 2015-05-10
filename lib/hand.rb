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

  def discard(card)
    raise NoCardError if @cards.delete(card).nil?
  end

  def <=>(other_hand)
    case hand_rank <=> other_hand.hand_rank
    when 1 then 1
    when -1 then -1
    else break_tie_with(other_hand)
    end
  end

  def ranks #returns a sorted array of each card's value (2-14, where ace is 14)
    @ranks ||= @cards.map(&:value).sort
  end

  private

  def check_hand # called whenever cards have changed
    @ranks = nil
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
    biggest_pairs_num == 3
  end

  def straight
    start = ranks.first
    ranks == (start..start + 4).to_a || ranks == [2, 3, 4, 5, 14]
  end

  def flush
    @cards.map(&:suit).uniq.one?
  end

  def full_house
    ranks.uniq.size == 2
  end

  def quads
    biggest_pairs_num == 4
  end

  def straight_flush
    flush && straight
  end

  def biggest_pairs_num
    @cards.inject(Hash.new(0)) do |counts, card|
      counts.tap { |c| c[card.value] += 1 }
    end.values.max
  end

  # tie breaking

  def break_tie_with(other_hand)
    case @hand_rank
      # high card, straight, flush, and straight flush
    when 1, 5, 6, 9 then high_card_comparison(other_hand)
      # one-pair, trips, or four-of-a-kind (quads)
    when 2, 4, 8 then single_pair_comparison(other_hand)
    when 3 then two_pair_comparison(other_hand)
    when 7 then full_house_comparison(other_hand)
    end
  end

  def high_card_comparison(other_hand)
    other_ranks = other_hand.ranks.reverse
    my_ranks = ranks.reverse
    my_ranks.each_with_index do |my_rank, i|
      return my_rank <=> other_ranks[i] unless (my_rank <=> other_ranks[i]) == 0
    end

    0
  end

  def single_pair_comparison(other_hand)
    case compare_pair(other_hand)
    when 1 then 1
    when -1 then -1
    else high_card_comparison(other_hand)
    end
  end

  def compare_pair(other_hand)
    our_pair = ranks.detect { |rank| ranks.count(rank) > 1 }
    their_pair = other_hand.ranks.detect { |rank| ranks.count(rank) > 1 }
    our_pair <=> their_pair
  end

  def two_pair_comparison(other_hand)
    our_pairs = ranks.select { |rank| ranks.count(rank) > 1 }.sort!
    their_pairs = other_hand.ranks.select { |rank| other_hand.ranks.count(rank) > 1 }
      .sort!

    case our_pairs.last <=> their_pairs.last
    when 1 then 1
    when -1 then -1
    else
      case our_pairs.first <=> their_pairs.first
      when 1 then 1
      when -1 then -1
      else ranks - our_pairs <=> other_hand.ranks - their_pairs
      end
    end
  end

  def full_house_comparison(other_hand)
    my_trips = ranks[2]
    their_trips = other_hand.ranks[2]
    case my_trips <=> their_trips
    when 1 then 1
    when -1 then -1
    else
      my_pair = ranks.reject { |rank| rank == my_trips }.uniq.first
      their_pair = other_hand.ranks.reject { |rank| rank == their_trips }.uniq.first
      my_pair <=> their_pair
    end
  end

end

class NoCardError < StandardError
end
