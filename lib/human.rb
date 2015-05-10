require_relative 'player'

class Human < Player
  CURSOR_MOVEMENT = {
    "\e[C" => 1,
    "\e[D" => -1,
    "\r"   => 0,
    "q"    => 0,
  }

  def get_input
    select_something = false
    until select_something
      input = read_char
      select_something = true if valid_input?(input)
    end
    exit if input == 'q'
    movement = CURSOR_MOVEMENT[input]
    case movement
    when 0 then register_action(@display.press_button!)
    else @display.update_cursor(movement)
    end
  end

  def register_action(button)
    p button.instance_variables
    case button.function
    when 'Discard' then register_discard(button.card_num); p instance_variables.map { |var| [var, instance_variable_get(var)] }
    when 'Confirm' then puts "Confirm!"
    when 'Raise', 'Bet' then puts "Raise!"
    when 'Call' then puts "Call!"
    when 'Check' then puts "Check!"
    when 'Fold' then puts "Fold!"
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
    when 'q' then true
    when "\e[C", "\e[D", "\r" then @display.inbounds?(CURSOR_MOVEMENT[input])
    else false
    end
  end

  def register_discard(card_num)
    instance_name = "@discard#{card_num}".to_sym
    flipped_value = instance_variable_get(instance_name) ? false : true
    instance_variable_set(instance_name, flipped_value)
  end
end
