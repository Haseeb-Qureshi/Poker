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
  CURSOR_MOVEMENT = {
    "\e[A" => [-1, 0],
    "\e[B" => [1, 0],
    "\e[C" => [0, 1],
    "\e[D" => [0, -1],
    "\r" => [0, 0],
  }
  Dir.chdir("lib/assets")
  CARDS_GRAPHICS = File.readlines('cards.txt')

  def initialize
    @deck = Deck.new
    @cursor = [0, 0]
  end

  def get_input
    select_something = false
    until select_something
      input = read_char
      select_something = true if valid_input?(input)
    end
    movement = CURSOR_MOVEMENT[input]
    if movement == [0, 0]
      select!
    else
      update_cursor(movement)
    end
  end

  def select!

  end

  def update_cursor(movement)
    x, y = @cursor
    dx, dy = movement
    @cursor = [x + dx, y + dy]
  end

  def read_char
    STDIN.echo = false
    STDIN.raw!
    input = STDIN.getc.chr
    if input == "\e"
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
  end

  def valid_input?(input)
    case input
    when "\e[A", "\e[B", "\e[C", "\e[D", "\r" then !overflow?(input)
    else false
    end
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

  def combine_images(str1, str2, str3, str4, str5)
    [].tap { |lines| 14.times do |i|
      if str1[i] &&  str2[i] &&  str3[i] &&  str4[i] &&  str5[i]
        lines << " " + [str1[i], str2[i], str3[i], str4[i], str5[i]].join(" ")
      end
    end }
  end

  def generate_card_image(card)
    row = VALUES_TABLE[card.value]
    col = SUITS_TABLE[card.suit]
    img = lookup_image(row, col)
    img = colorize_image(img, card)
    img = add_card_name(img, card)
    img = add_discard_option(img)
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
    img << my_value.bold
    img << of.bold
    img << my_suit.bold.colorize(color: color).underline
  end

  def add_discard_option(img)
    @cursor -
    img << " ".rjust(11)
    img << " ".rjust(11).on_yellow
    img << "Discard".center(11).red.bold.on_yellow
    img << " ".rjust(11).on_yellow
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
