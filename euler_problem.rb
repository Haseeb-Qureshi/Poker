require_relative 'lib/hand'
require_relative 'lib/card'
require_relative 'converted_euler_hands'

HAND_VALUES = {
  :T => 10,
  :J => 11,
  :Q => 12,
  :K => 13,
  :A => 14,
}

def parse(str)
  each_card = str.scan(/../)
  each_card.each_with_object([]) do |card, cards|
    val = card[0]
    val = HAND_VALUES[val.to_sym] ? HAND_VALUES[val.to_sym] : val.to_i
    suit = card[1].downcase.to_sym
    cards << Card.new(val, suit)
  end
end

cards_array = A.map { |arr| arr.map { |str| Hand.new(parse(str)) } }
puts cards_array.count { |card1, card2| card1 > card2 }
