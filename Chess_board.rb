require './Chess_piece'
class ChessBoard
  attr_accessor :board

  def initialize
    @board = Array.new(8) { |row| Array.new(8) {nil} }
  end

  def populate_board
    self[[7,0]] = Queen.new(self,[7,0], :w)
    self[[6,1]] = Pawn.new(self,[6,1], :w)
    self[[7,1]] = Pawn.new(self,[7,1], :b)
    self[[5,2]] = Pawn.new(self,[5,2], :b)
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



end
