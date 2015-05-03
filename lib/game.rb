require_relative 'player'
require_relative 'computer'
require_relative 'deck'
require_relative 'hand'
require_relative 'interface'
require 'colorize'
require 'io/console'

class Game
  def initialize
    @deck = Deck.new
    @interface = Interface.new(@deck)
    @players = [Player.new(self, @interface), Computer.new(self, @interface)]
    @stakes = 50
    @pot = 0
  end

  def start
    welcome
    play
  end

  def play
    render
    until @players.any?(&:bust?)
      deal_in
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
    puts "Now, to begin: we're each going to start with $1000."
    sleep(4)
    puts "Stakes start at $50 per bet. They go up every minute, so play fast."
    sleep(4.5)
    puts "Let's deal!"
    sleep(2)
  end

  def render
    @interface.render(@human_roll, @computer_roll, [])
  end

  def deal_in
    @players.each { |player| player.new_hand(@deck) }
  end

  def current_player
    @players.first
  end

  def new_hand
    # current_player.make_draw
    # @players.last.make_draw
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
