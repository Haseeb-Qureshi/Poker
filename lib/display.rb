VALUES_TABLE = {
  14 => 0,
  13 => 10,
  12 => 20,
  11 => 30,
  10 => 41,
  9 => 52,
  8 => 63,
  7 => 74,
  6 => 85,
  5 => 96,
  4 => 107,
  3 => 118,
  2 => 129,
}

SUITS_TABLE = {
  :c => 0,
  :d => 20,
  :h => 40,
  :s => 60,
}

Dir.chdir("assets")
CARDS_GRAPHICS = File.readlines('cards.txt')

def render
  card = @deck.take_one
  puts "#{card.value} #{card.suit}"
  puts generate_card_image(@deck.take_one)
  sleep(3)
end

def generate_card_image(card)
  i = VALUES_TABLE[card.value]
  j = SUITS_TABLE[card.suit]
  lookup_image(i, j, CARDS_GRAPHICS)
end

def lookup_image(i, j, graphics)
  graphics[i..(i + 8)].map { |img| img[j..(j + 11)] }
end


#
# begin
#           [0..8].map { |str| str[0..11] } for ace of clubs
#           [0..8].map { |str| str[20..31] } for ace of diamonds
#           [0..8].map { |str| str[40..51] } for ace of hearts
#           [0..8].map { |str| str[60..71] } for ace of spades
#
# end
