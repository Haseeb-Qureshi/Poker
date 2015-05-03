class Card
  attr_reader :value, :suit
  attr_accessor :selected

  def initialize(value, suit)
    @value = value
    @suit = suit
    @selected = false
  end
end
