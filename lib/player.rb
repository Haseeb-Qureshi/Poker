class Player
  attr_reader :bankroll
  CURSOR_MOVEMENT = {
    "\e[A" => [-1, 0],
    "\e[B" => [1, 0],
    "\e[C" => [0, 1],
    "\e[D" => [0, -1],
    "\r"   => [0, 0],
  }

  def initialize(game, display)
    @bankroll = 1000
    @game = game
    @display = display
  end

  def bust?
    @bankroll == 0
  end

  def call_bet(bet)
  end

  def raise(bet)
  end

  def fold
  end

  def get_input
    select_something = false
    until select_something
      input = read_char
      select_something = true if valid_input?(input)
    end
    movement = CURSOR_MOVEMENT[input]
    if movement == [0, 0]
      @display.select!
    else
      @display.update_cursor(movement)
    end
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
end
