require 'deck'

describe Deck do
  describe "Dealing" do
    subject(:deck) { Deck.new }

    describe "#cards_left" do
      it "starts with 52 cards" do
        expect(deck.cards_left).to eq(52)
      end
    end

    describe "#take_one" do
      it "deals different cards" do
        expect(deck.take_one).to_not eq(deck.take_one)
      end

      it "gives you a card" do
        expect(deck.take_one).to be_a(Card)
      end

      it "removes one card from the deck" do
        expect { deck.take_one }.to change { deck.cards_left }.from(52).to(51)
      end
    end
  end
end
