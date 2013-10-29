require './Chess_piece'
class ChessBoard
  attr_accessor :board, :kings, :black_king, :white_king

  def initialize
    @board = Array.new(8) { |row| Array.new(8) { nil } }
  end

  def populate_board
    Queen.new(self,[7,0], :w)
    @black_king = King.new(self, [0,0], :b)
    @white_king = King.new(self, [7,7], :w)
    @kings = {:b => self.black_king, :w => self.white_king}
    Castle.new(self, [7,1], :w)
    nil
  end

  def []=(pos, value)
    row, col = pos
    board[row][col] = value
  end

  def [](pos)
    row, col = pos
    board[row][col]
  end

  #use as a shortcut to break from checkmate if king can escape
  def get_danger_zone(color)
    danger_zone = []
    board.flatten.compact.each do |piece|
        danger_zone += piece.possible_moves if piece.player != color
    end
    danger_zone
  end

  def checked?(color)
    get_danger_zone(color).include? (kings[color].pos)
  end

  def check_mated?(color)
    dz = get_danger_zone(color)
    return true if kings[color].possible_moves.all? { |move| dz.include? move }

    #see if king can be protected by other player
    false
  end

end
#load './Chess_board.rb'; game = ChessBoard.new; game.populate_board; game.board
