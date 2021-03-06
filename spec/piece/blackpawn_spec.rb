require_relative 'shared_examples_for_pieces'
require './lib/piece/blackpawn'

describe BlackPawn do
  let(:subject) { BlackPawn.new('white') }

  it_behaves_like 'a Piece'
  it_behaves_like 'a PieceSubclass'

  describe "#try_path(a,b,direction)" do
    context "when a path exists going from a to b in a given direction in one step" do
      it "returns the path as an array of coordinates" do
        a = [3,3]
        b = [3,2]
        direction = subject.down      
        result = [[3,3],[3,2]]
        expect(subject.try_path(a,b,direction)).to eql(result)
      end
    end

    context "when no path can be found in the given direction" do
      it "returns nil" do
        a = [3,3]
        b = [3,4]
        direction = subject.down
        expect(subject.try_path(a,b,direction)).to be nil
      end
    end

    context "when b can't be reached in one step" do
      it "returns nil" do
        a = [3,3]
        b = [3,1]
        direction = subject.down
        expect(subject.try_path(a,b,direction)).to be nil
      end
    end

    context "when b is outside of the board" do
      it "returns nil" do
        a = [0,0]
        b = [0,-1]
        direction = subject.down
        expect(subject.try_path(a,b,direction)).to be nil
      end
    end
  end

  describe "#directions" do
    it "supplies the allowed directions" do
      directions = [
        subject.down
      ]
      expect(subject.directions).to match_array(directions)
    end
  end

  describe "#special_moves" do
    it "supplies the allowed special moves" do
      result = [
        'two steps',
        'capture'
      ]
      expect(subject.special_moves).to match_array(result)
    end
  end

  describe "#get_special_move(a,b)" do
    context "when the requested move is one of the piece's special moves" do
      context "when b is outside of the board" do
        it "returns nil" do
          a = [0,6]
          b = [-1,5]
          expect(subject.get_special_move(a,b)).to be nil
        end
      end

      context "when the pawn can move two steps" do
        it "returns a move-like object that can be queried for the piece, the path from a to b and the name of the special move" do
          a = [3,6]
          b = [3,4]
          expect(subject.get_special_move(a,b).piece).to eql(subject)
          expect(subject.get_special_move(a,b).path).to eql([[3,6],[3,5],[3,4]])
          expect(subject.get_special_move(a,b).name).to eql('two steps')
        end
      end

      context "when the pawn can make a capture" do
        it "returns a move-like object that can be queried for the piece, the path from a to b and the name of the special move" do
          a = [2,5]
          b = [1,4]
          expect(subject.get_special_move(a,b).piece).to eql(subject)
          expect(subject.get_special_move(a,b).path).to eql([[2,5],[1,4]])
          expect(subject.get_special_move(a,b).name).to eql('capture')
        end
      end
    end

    context "when the requested move is not one of the piece's special moves" do
      it "returns nil" do
        a = [2,5]
        b = [2,3]
        expect(subject.get_special_move(a,b)).to be nil
      end
    end
  end
end