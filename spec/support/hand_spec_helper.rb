HAND_VALUES = {
  :T => 10,
  :J => 11,
  :Q => 12,
  :K => 13,
  :A => 14
}

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

def parse(str)
  cards = []
  hand_strs = str.scan(/../)
  hand_strs.each do |hand_str|
    val = hand_str[0]
    val = HAND_VALUES[val.to_sym] ? HAND_VALUES[val.to_sym] : val.to_i
    suit = hand_str[1].to_sym
    cards << double('card', value: val, suit: suit)
  end
  cards
end
