require_relative 'player'

class Human < Player
  CURSOR_MOVEMENT = {
    "\e[A" => [-1, 0],
    "\e[B" => [1, 0],
    "\e[C" => [0, 1],
    "\e[D" => [0, -1],
    "\r"   => [0, 0],
  }

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
    when "\e[A", "\e[B", "\e[C", "\e[D", "\r" then !Interface.overflow?(input)
    else false
    end
  end
end
