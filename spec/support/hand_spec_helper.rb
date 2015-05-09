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
    cards << Card.new(val, suit) # change this back to a double later
  end
end

def high_card
  Hand.new(parse('3h4h7c9cTh'))
end

def pair
  Hand.new(parse('5c6h4d4c9s'))
end

def two_pair
  Hand.new(parse('2c4c2d4d9s'))
end

def trips
  Hand.new(parse('3h3c3d8hAc'))
end

def straight
  Hand.new(parse('2h3c4d5c6h'))
end

def flush
  Hand.new(parse('3h6h9h4h5h'))
end

def full_house
  Hand.new(parse('5h5c5d3d3h'))
end

def quads
  Hand.new(parse('2h2d2c2s4s'))
end

def straight_flush
  Hand.new(parse('3h4h5h6h7h'))
end
