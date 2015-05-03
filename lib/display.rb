class Display
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
    14 => "Ace",
    13 => "King",
    12 => "Queen",
    11 => "Jack",
    10 => "Ten",
    9 => "Nine",
    8 => "Eight",
    7 => "Seven",
    6 => "Six",
    5 => "Five",
    4 => "Four",
    3 => "Three",
    2 => "Deuce",
  }
  SUIT_TO_WORD = {
    :c => "Clubs",
    :d => "Diamonds",
    :h => "Hearts",
    :s => "Spades",
  }

  Dir.chdir("lib/assets")
  CARDS_GRAPHICS = File.readlines('cards.txt')

  def initialize
    @deck = Deck.new
    @cursor = [0, 0]
  end

  def overflow?(input)
    x, y = @cursor
    dx, dy = CURSOR_MOVEMENT[input]
    (x + dx).between?(0, 5) && (y + dy).between?(0, 2)
  end

  def render(player_bankroll, computer_bankroll, cards)
    system 'clear'
    puts ("Player bankroll: " + "1000".green).rjust(90)
    puts ("Computer bankroll: " + "1000".yellow).rjust(90)
    card1 = @deck.take_one
    card2 = @deck.take_one
    card3 = @deck.take_one
    card4 = @deck.take_one
    card5 = @deck.take_one
    str1 = generate_card_image(card1)
    str2 = generate_card_image(card2)
    str3 = generate_card_image(card3)
    str4 = generate_card_image(card4)
    str5 = generate_card_image(card5)
    # p @deck.cards_left
    puts combine_images(str1, str2, str3, str4, str5)
    sleep(1)
  end

  def update_cursor(movement)
    x, y = @cursor
    dx, dy = movement
    @cursor = [x + dx, y + dy]
  end

  def select!

  end

  def combine_images(str1, str2, str3, str4, str5)
    [].tap { |lines| 14.times do |i|
      if str1[i] &&  str2[i] &&  str3[i] &&  str4[i] &&  str5[i]
        lines << " " + [str1[i], str2[i], str3[i], str4[i], str5[i]].join(" ")
      end
    end }
  end

  def generate_card_image(card) # MAKE THESE CARDS AND IMAGES PERSIST UNTIL
    row = VALUES_TABLE[card.value] # THE NEXT TURN. YOU WANT PERSISTENT BUTTON OBJECTS,
    col = SUITS_TABLE[card.suit] # SO THEY CAN TRACK THEIR STATE OF ACTIVATION OR NOT.
    img = lookup_image(row, col) # ONLY CALL A FULL *RE-CREATION* ONCE A MOVE HAS BEEN
    img = colorize_image(img, card) # MADE.
    img = add_card_name(img, card)
    discard = add_discard_option(img)
    button = add_button(img)
  end

  def lookup_image(x, y)
    img = CARDS_GRAPHICS[x..(x + 6)].map { |line| " " + line[y..(y + 8)] + " " }
  end

  def colorize_image(img, card)
    color = case card.suit
    when :s, :c then :black
    when :h, :d then :red
    end
    img.map { |line| line.colorize(color: color, background: :white) }
  end

  def add_card_name(img, card)
    color = case card.suit
    when :s then :black
    when :c then :green
    when :h then :red
    when :d then :blue
    end
    my_value = VALUE_TO_WORD[card.value].center(11)
    of = " of".center(11)
    my_suit = SUIT_TO_WORD[card.suit].rjust(11)
    space = " ".rjust(11)
    img << my_value.bold
    img << of.bold
    img << my_suit.bold.colorize(color: color).underline
    img << space
  end

  def add_discard_option(img) # THE CARD WILL TELL YOU WHETHER ITS BEEN SELECTED FOR DISCARDING
    option = Button.new
    option << " ".rjust(11).red.on_yellow
    option << "Discard".center(11).red.bold.on_yellow
    option << " ".rjust(11).red.on_yellow
  end

  def add_button(img)
    draw = Button.new
    draw << " ".center(60)
    draw << " ".center(60).white.on_black
    draw << "DRAW".center(60).white.on_black
    draw << " ".center(60).white.on_black
  end
end

class Button < Array
  attr_accessor :selected
  def initialize(*args, &block)
    super(*args, &block)
    @selected = false
  end

  def <<(line)
    USE SELECTED? TO SWAP THE SHOVELED IN ITEM
  end
end


#
# begin
#           [0..8].map { |str| str[0..11] } for ace of clubs
#           [0..8].map { |str| str[20..31] } for ace of diamonds
#           [0..8].map { |str| str[40..51] } for ace of hearts
#           [0..8].map { |str| str[60..71] } for ace of spades
#
# end
