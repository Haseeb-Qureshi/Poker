require_relative 'assets/cards_art'

class Interface
  attr_writer :human, :computer
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

  def initialize(game, deck)
    @game = game
    @deck = deck
    @cursor = [0, 0]
    @cards = [@card1, @card2, @card3, @card4, @card5]
    @final_round = false
  end

  #All cursor logic should work.
  #Cursor starts at 0, 0. After the final round (when discard buttons disappear),
  #the cursor goes to 1, 0. It resumes Y-functionality the next turn.

  #Each turn should render appropriately based on what is required. (Raising or calling or folding, etc.)
  #The only thing that remains to be done is to activate the _.cursor_over_ on the button if it's on the cursor.
  #This can be done by making the whole display part (discards + buttons) one giant array. (Right?)
  #Sure. Put each button in the array, then cursor the right one, then swap 'em.'


  #Put this logic into the game class.

  #Decide what initializations to do. If someone bets, then show a raise to someone else.
  #(Feel free to re-write player classes if necessary.)
  #Write tests later. First decide your architecture and implementation
  #and make sure that it ultimately makes sense.

  #Game takes moves from computer and player (in order of who goes first, which rotates).
  #Then it calls the right info to render.
  #If the player goes all-in, then future streets are skipped.
  #The game can check this by checking #bust? on either player on any given street.

  #There can also be a BankrollError raised by the player, which will trigger skips of future streets.

  #The cursor updates from the player <-> interface.

  #Computer AI can be implemented later. For now it will always stand pat?



  def render_turn
    system 'clear'
    puts bankrolls
    puts combine_cards(*@cards)
    puts combine_discards
    puts computer_message
    puts combine_buttons
    sleep(5)
  end

  def render_showdown
    system 'clear'
    puts bankrolls
    puts combine_cards(@cards)
    puts combine_cards(@cpu_cards)
    puts computer_message
  end

  def bankrolls
    bankrolls = []
    bankrolls << ("Player bankroll: $" + @human.bankroll.to_s.green).rjust(90)
    bankrolls << ("Computer bankroll: $" + @computer.bankroll.to_s.yellow).rjust(90)
    bankrolls << ("BB:   $" + @game.stakes.to_s.white).rjust(90)
  end

  def combine_cards(*cards)
    combine_images(cards, 11)
  end

  def combine_discards
    combine_images(@discards, 3)
  end

  def combine_buttons
    combine_images(@buttons, 3)
  end

  def set_new_turn
    @card1 = generate_card_image(@human.cards[0])
    @card2 = generate_card_image(@human.cards[1])
    @card3 = generate_card_image(@human.cards[2])
    @card4 = generate_card_image(@human.cards[3])
    @card5 = generate_card_image(@human.cards[4])
    @discard1 = Button.discard
    @discard2 = Button.discard
    @discard3 = Button.discard
    @discard4 = Button.discard
    @discard5 = Button.discard
    @fold = Button.fold
    @final_round = false
    init_image_groups
  end

  def set_first_to_bet
    @bet_raise = Button.bet
    @check_call = Button.check
    init_image_groups
  end

  def set_facing_a_bet
    @bet_raise = Button.raise
    @check_call = Button.call
    init_image_groups
  end

  def set_final_round
    @cursor = [1, 0]
    @discards = []
    @final_round = true
  end

  def set_showdown
    @cpu_card1 = generate_card_image(@computer.cards[0])
    @cpu_card2 = generate_card_image(@computer.cards[1])
    @cpu_card3 = generate_card_image(@computer.cards[2])
    @cpu_card4 = generate_card_image(@computer.cards[3])
    @cpu_card5 = generate_card_image(@computer.cards[4])
    init_image_groups
  end

  def render(player_bankroll, computer_bankroll, cards)
    system 'clear'
    set_new_turn
    set_first_to_bet
    render_turn
    sleep(1)
  end

  def computer_message
    message = []
    message << " ".center(60)
    message << @computer.message.center(60)
    message << " ".center(60)
  end

  def init_image_groups #fills in the arrays with most recent versions
    @cards = [@card1, @card2, @card3, @card4, @card5]
    @discards = [@discard1, @discard2, @discard3, @discard4, @discard5]
    @buttons = [@bet_raise, @check_call, @fold]
    @cpu_cards = [@cpu_card1, @cpu_card2, @cpu_card3, @cpu_card4, @cpu_card5]
    @cursorable = [@discards, @buttons]
  end

  def highlight_cursorable
    x, y = @cursor
    @cursorable[x][y].cursor_over
  end

  def update_cursor(movement)
    if movement == [1, 0] # mapping for moving down
      if @cursor === [[0, 0], [0, 1]]
        @cursor = [1, 0]
      elsif @cursor == [0, 2]
        @cursor = [1, 1]
      else
        @cursor = [1, 2]
      end
    elsif movement == [-1, 0] # mapping for moving up
      if @cursor == [1, 0]
        @cursor = [0, 0]
      elsif @cursor == [1, 1]
        @cursor = [0, 2]
      else
        @cursor = [0, 3]
      end
    else
      x, y = @cursor
      dx, dy = movement
      @cursor = [x + dx, y + dy]
    end
  end

  def combine_images(images, num_lines)
    combined_image = []
    num_lines.times do |i|
      if images.any?
        combined_image << " " +  images.map { |image| image[i] }.join(" ")
      end
    end
    combined_image
  end

  def generate_card_image(card)
    row = VALUES_GRAPHICS_LOOKUP[card.value]
    col = SUITS_GRAPHICS_LOOKUP[card.suit]
    img = lookup_image(row, col)
    img = colorize_image(img, card)
    img = add_card_name(img, card)
    img
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

  def overflow?(input) #depends on the state of the interface -- are there discard buttons being used?
    x, y = @cursor
    dx, dy = CURSOR_MOVEMENT[input]
    unless @final_round
      (x + dx).between?(0, 4) && (y + dy).between?(0, 1)
    else
      (x + dx).between?(0, 2) && (y + dy) == 1
    end
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
    bet << " ".rjust(18).white.on_black
    bet << function.center(18).white.on_black
    bet << " ".rjust(18).white.on_black
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

  def cursor_over
    i = 0
    map do |el|
      i += 1
      i == 2 ? @function.center(@just).underline.send(@fg).send(@bg) : el
    end
  end
end
