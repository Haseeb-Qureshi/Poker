VALUES_TABLE = {
  14 => 1,
  13 => 11,
  12 => 21,
  11 => 31,
  10 => 42,
  9 => 53,
  8 => 64,
  7 => 75,
  6 => 85,
  5 => 95,
  4 => 105,
  3 => 115,
  2 => 125,
}

SUITS_TABLE = {
  :c => 2,
  :d => 22,
  :h => 42,
  :s => 62,
}

VALUE_TO_WORD = {
  14 => "A",
  13 => "K",
  12 => "Q",
  11 => "J",
  10 => "T",
}

Dir.chdir("lib/assets")
CARDS_GRAPHICS = File.readlines('cards.txt')

def render
  card1 = @deck.take_one
  card2 = @deck.take_one
  card3 = @deck.take_one
  str = generate_card_image(card1)
  str2 = generate_card_image(card2)
  str3 = generate_card_image(card3)
  p @deck.cards_left
  10.times do |i|
    puts " " + str[i] + " " + str2[i] + " " + str3[i] if str[i] && str2[i] && str3[i]
  end
  sleep(1)
end

def generate_card_image(card)
  row = VALUES_TABLE[card.value]
  col = SUITS_TABLE[card.suit]
  img = lookup_image(row, col)
  img = colorize_image(img, card)
  img = add_name_to_image(img, card)
end

def lookup_image(x, y)
  img = CARDS_GRAPHICS[x..(x + 6)].map { |line| " " + line[y..(y + 8)] + " " }
end

def colorize_image(img, card)
  color = case card.suit
  when :s then :black
  when :h then :red
  when :c then :green
  when :d then :blue
  end
  img.map { |line| line.colorize(color: color, background: :white) }
end

def add_name_to_image(img, card)
  my_value = VALUE_TO_WORD[card.value] ? VALUE_TO_WORD[card.value] : card.value
  img << "    #{my_value}#{card.suit}     "
end


#
# begin
#           [0..8].map { |str| str[0..11] } for ace of clubs
#           [0..8].map { |str| str[20..31] } for ace of diamonds
#           [0..8].map { |str| str[40..51] } for ace of hearts
#           [0..8].map { |str| str[60..71] } for ace of spades
#
# end
