require 'hand'
require_relative 'support/hand_spec_helper'

describe Hand do
  describe "hand methods" do
    let(:new_card) { double(:new_card, value: 4, suit: :s) }
    let(:deck) { double('deck', take_one: new_card) }
    subject(:hand) { Hand.new([], deck) }

    describe "#cards" do
      it "should return all of the cards in the hand" do
        2.times { hand.take_card }
        expect(hand.cards).to eq([new_card, new_card])
      end
    end

    describe "#take_card" do
      it "should take a new card when dealt" do
        expect { hand.take_card }.to change { hand.cards.length }.by(1)
      end
    end

    describe "#discard_card" do
      context "when has a card" do
        before(:each) { hand.take_card }

        it "should discard a card" do
          hand.discard_card(0)
          expect(hand.cards).to be_empty
        end
      end

      context "when no card" do
        it "should raise an error" do
          expect { hand.discard_card(0) }.to raise_error
        end
      end
    end
  end

  describe "#<=>" do
    let(:a_high_card) { high_card }
    let(:a_pair) { pair }
    let(:a_two_pair) { two_pair }
    let(:a_trips) { trips }
    let(:a_straight) { straight }
    let(:a_flush) { flush }
    let(:a_full_house) { full_house }
    let(:a_quads) { quads }
    let(:a_straight_flush) { straight_flush }

    describe "#<=>" do
      context "higher vs lower" do
        specify "straight_flush beats quads" do
          expect(a_straight_flush).to be > a_quads
        end

        specify "quads beats full_house" do
          expect(a_quads).to be > a_full_house
        end

        specify "full_house beats flush" do
          expect(a_full_house).to be > a_flush
        end

        specify "flush beats straight" do
          expect(a_flush).to be > a_straight
        end

        specify "straight beats trips" do
          expect(a_straight).to be > a_trips
        end

        specify "trips beats two_pair" do
          expect(a_trips).to be > a_two_pair
        end

        specify "two_pair beats a pair" do
          expect(a_two_pair).to be > a_pair
        end

        specify "a pair beats high card" do
          expect(a_pair).to be > a_high_card
        end
      end

      context "same hand" do
        specify "trips equals other trips" do
          expect(a_trips).to eq(a_trips)
        end

        specify "equivalent straight equals other straight" do
          other_straight = Hand.new(parse("2c3h4d5c6h"))
          expect(a_straight).to eq(other_straight)
        end

        specify "equivalent flush equals other flush" do
          other_flush = Hand.new(parse("3c6c9c4c5c"))
          expect(a_flush).to eq(other_flush)
        end
      end

      context "tie-breakers" do
        specify "ace-high should beat ten-high" do
          ace_high = Hand.new(parse('Ac5h4c9cTd'))
          expect(ace_high).to be > a_high_card
        end

        specify "higher two pair beats lower two pair" do
          higher_two_pair = Hand.new(parse('2d2c9h9sAd'))
          expect(higher_two_pair).to be > a_two_pair
        end

        specify "higher two pair(second) beats lower two pair (second)" do
          higher_two_pair = Hand.new(parse('4c4h3h3c8d'))
          expect(higher_two_pair).to be > a_two_pair
        end

        specify "higher straight beats lower straight" do
          higher_straight = Hand.new(parse('3h4h5c6c7d'))
          expect(higher_straight).to be > a_straight
        end

        specify "higher flush beats lower flush" do
          higher_flush = Hand.new(parse('8h9hKhAh4h'))
          expect(higher_flush).to be > a_flush
        end

        specify "bigger full house beats lower full house" do
          big_full = Hand.new(parse('AhAdAc9s9d'))
          expect(big_full).to be > a_full_house
        end

        specify "bigger full house(2nd) beats lower full house(2nd)" do
          big_full = Hand.new(parse('5h5c5d4d4h'))
          expect(big_full).to be > a_full_house
        end

        specify "pair with higher kicker beats one with lower kicker" do
          low_kick_pair = Hand.new(parse('4h4s3h5d6h'))
          expect(a_pair).to be > low_kick_pair
        end

        specify "two pair with higher kicker beats same with lower kicker" do
          low_kick_two_pair = Hand.new(parse('2h2s4h4d7h'))
          expect(two_pair).to be > low_kick_two_pair
        end
      end
    end
  end
end
