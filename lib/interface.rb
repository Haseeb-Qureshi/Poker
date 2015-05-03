require_relative 'assets/cards_art'

class Interface
  CARDS_GRAPHICS = ASCII_CARDS.lines
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
  VALUES_GRAPHICS_LOOKUP = {
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
  SUITS_GRAPHICS_LOOKUP = {
    :c => 2,
    :d => 22,
    :h => 42,
    :s => 62,
  }

  def initialize(deck)
    @deck = deck
    @cursor = [0, 0]
    @cards = [@card1, @card2, @card3, @card4, @card5]
  end

  def set_new_turn
    @card1 = generate_card_image(@player.cards[0])
    @card2 = generate_card_image(@player.cards[1])
    @card3 = generate_card_image(@player.cards[2])
    @card4 = generate_card_image(@player.cards[3])
    @card5 = generate_card_image(@player.cards[4])
    @discard1 = Button.discard
    @discard2 = Button.discard
    @discard3 = Button.discard
    @discard4 = Button.discard
    @discard5 = Button.discard
    @fold = Button.fold
    init_images
  end

  def set_first_to_bet
    @bet_raise = Button.bet
    @check_call = Button.check
    init_images
  end

  def set_facing_a_bet
    @bet_raise = Button.raise
    @check_call = Button.call
    init_images
  end

  def set_final_round
    @discards = []
  end

  def set_showdown
    @cpu_card1 = generate_card_image(@computer.cards[0])
    @cpu_card2 = generate_card_image(@computer.cards[1])
    @cpu_card3 = generate_card_image(@computer.cards[2])
    @cpu_card4 = generate_card_image(@computer.cards[3])
    @cpu_card5 = generate_card_image(@computer.cards[4])
  end

  def render(player_bankroll, computer_bankroll, cards)
    system 'clear'
    puts ("Player bankroll: " + "1000".green).rjust(90)
    puts ("Computer bankroll: " + "1000".yellow).rjust(90)
    @card1 = generate_card_image(@deck.take_one)
    @card2 = generate_card_image(@deck.take_one)
    @card3 = generate_card_image(@deck.take_one)
    @card4 = generate_card_image(@deck.take_one)
    @card5 = generate_card_image(@deck.take_one)
    init_images
    puts combine_images(*@cards)
    sleep(1)
  end

  def update_cursor(movement)
    x, y = @cursor
    dx, dy = movement
    @cursor = [x + dx, y + dy]
  end

  def combine_images(str1, str2, str3, str4, str5)
    lines = []
    14.times do |i|
      if str1[i] &&  str2[i] &&  str3[i] &&  str4[i] &&  str5[i]
        lines << " " + [str1[i], str2[i], str3[i], str4[i], str5[i]].join(" ")
      end
    end
    lines
  end

  def generate_card_image(card)
    row = VALUES_GRAPHICS_LOOKUP[card.value]
    col = SUITS_GRAPHICS_LOOKUP[card.suit] #
    img = lookup_image(row, col) 
    img = colorize_image(img, card)
    img = add_card_name(img, card)
    discard = Button.discard.cursor_over
    img + discard
  end

  def lookup_image(x, y)
    img = CARDS_GRAPHICS[x..(x + 6)].map { |line| " " + line[y..(y + 8)] + " " }
  end

  def colorize_image(img, card)
    color = color_map(card.suit)
    img.map { |line| line.colorize(color: color, background: :white) }
  end

  def add_card_name(img, card)
    color = color_map(card.suit)
    my_value = VALUE_TO_WORD[card.value].center(11)
    of = " of".center(11)
    my_suit = SUIT_TO_WORD[card.suit].rjust(11)
    space = " ".rjust(11)
    img << my_value.bold
    img << of.bold
    img << my_suit.bold.colorize(color: color).underline
    img << space
  end

  def color_map(suit)
    case suit
    when :s then :black
    when :c then :green
    when :h then :red
    when :d then :blue
    end
  end

  def add_computer_message
    message = Button.new
    message << " ".center(60)
    message << @computer.message.center(60)

  end

  def self.overflow?(input)
    x, y = @cursor
    dx, dy = CURSOR_MOVEMENT[input]
    (x + dx).between?(0, 5) && (y + dy).between?(0, 2)
  end

  def init_images
    @cards = [@card1, @card2, @card3, @card4, @card5]
    @discards = [@discard1, @discard2, @discard3, @discard4, @discard5]
    @buttons = [@bet_raise, @check_call, @fold]
  end

end

class Button < Array
  def self.discard
    discard = Button.new("Discard", 11, :red, :on_yellow)
    discard << " ".rjust(11).red.on_yellow
    discard << "Discard".center(11).red.bold.on_yellow
    discard << " ".rjust(11).red.on_yellow
  end

  def self.bet
    Button.custom_button("Bet")
  end

  def self.raise
    Button.custom_button("Raise")
  end

  def self.check
    Button.custom_button("Check")
  end

  def self.call
    Button.custom_button("Call")
  end

  def self.fold
    Button.custom_button("Fold")
  end

  def self.custom_button(function)
    bet = Button.new(function, 18, :white, :on_black)
    button << " ".rjust(18).white.on_black
    button << function.center(18).white.on_black
    button << " ".rjust(18).white.on_black
  end

  def initialize(function, just, fg, bg)
    super()
    @function = function
    @just = just
    @fg = fg
    @bg = bg
    @selected = false
    @cursor_over = false
  end

  def select!
    map!(&:swap)
    @fg, @bg = @bg, @fg
    @selected = @selected == true ? false : true
    self
  end

  def cursor_over #Returns a COPY with underline
    i = 0
    map do |el|
      i += 1
      i == 2 ? @function.center(@just).underline.send(@fg).send(@bg) : el
    end
  end
end
