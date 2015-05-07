require_relative 'player'

class Human < Player
  CURSOR_MOVEMENT = {
    "\e[C" => 1,
    "\e[D" => -1,
    "\r"   => 0,
  }

  def get_input
    select_something = false
    until select_something
      input = read_char
      select_something = true if valid_input?(input)
    end
    movement = CURSOR_MOVEMENT[input]
    if movement == 0
      @display.make_selection
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
    when "\e[C", "\e[D", "\r" then @display.inbounds?(CURSOR_MOVEMENT[input])
    else false
    end
  end
end
