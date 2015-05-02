require_relative 'player'
require_relative 'deck'
require_relative 'hand'
require_relative 'display'

class Game
  def initialize
    @players = [Player.new, Player.new]
    @deck = Deck.new
    @stakes = 10
    @pot = 0
  end

  def start
    welcome
    play
  end

  def play
    render
    until @players.any?(&:bust?)
      new_hand
      @players.rotate!
      render
    end
    game_over_message
  end

  private

  def welcome
    system 'clear'
    puts "Welcome to 5 Card Draw!"
    sleep(2)
    puts "I, the Pokertron 5000, will be your humble opponent."
    sleep(3)
    puts "Now, to begin: we're each going to start with $500."
    sleep(4)
    puts "Stakes start at $5/$10. They go up every minute, so play fast."
    sleep(4.5)
    puts "Let's deal!"
    sleep(2)
  end

  def new_hand
  end

  def game_over_message
    system 'clear'
    puts "Game over! #{@players.first} was the winner."
    puts "This program uses Bej's card ASCII art."
  end
end

if __FILE__ == $0
  #Game.new.start
  Game.new.play
end
