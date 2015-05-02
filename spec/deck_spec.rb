require 'deck'

describe Deck do
  describe "Dealing methods" do
    subject(:deck) { Deck.new }

    describe "#initialize" do
      it "starts with 52 cards" do
        expect(deck.cards_left).to eq(52)
      end
    end

    describe "#take_one" do
      # let(:deck2) { Deck.new }

      it "deals different cards" do
        expect(deck.take_one).to_not eq(deck.take_one)
      end

      it "gives you a card" do
        # expect(deck.take_one.class).to be(Card)
        expect(deck.take_one).to be_a(Card)
      end
    end
  end
end
