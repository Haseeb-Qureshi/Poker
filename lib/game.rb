require_relative 'human'
require_relative 'computer'
require_relative 'deck'
require_relative 'hand'
require_relative 'interface'
require 'colorize'
require 'io/console'

class Game
  attr_reader :stakes
  
  def initialize
    @deck = Deck.new
    @interface = Interface.new(self, @deck)
    @players = [Human.new(self, @interface), Computer.new(self, @interface)]
    @stakes = 50
    @pot = 0
    @winner = nil
  end

  def start
    welcome
    play
  end

  def play
    init_interface   # DO THIS LATER
  #  render              UNDO THIS LATER?
    until @players.any?(&:bust?)
      deal_in_players
      play_hand
      award_pot
      prepare_for_next_hand
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
    puts "Now, to begin: we're each going to start with $1000."
    sleep(4)
    puts "Stakes start at $50 per bet. They go up every minute, so play fast."
    sleep(4.5)
    puts "Let's deal!"
    sleep(2)
    init_interface
  end

  def render
    @interface.render(@human_roll, @computer_roll, [])
  end

  def play_hand
    render

  end

  def deal_in_players
    @players.each { |player| player.take_new_hand(@deck) }
  end

  def award_pot
    @winner.bankroll += @pot
  end

  def prepare_for_next_hand
    @players.rotate!
    @deck = Deck.new
  end

  def current_player
    @players.first
  end

  def init_interface
    @interface.human = @players.first
    @interface.computer = @players.last
  end

  def game_over_message
    system 'clear'
    puts "Game over! #{@winner} was the winner."
    puts "This program uses Bej's card ASCII art."
  end
end

if __FILE__ == $0
  #Game.new.start
  Game.new.play
end
