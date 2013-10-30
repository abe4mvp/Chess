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
    board.flatten.compact.each do |piece| #replace with active_piece_list
        danger_zone += piece.possible_moves if piece.color != color
    end
    danger_zone
  end

  def all_active_pieces
    board.flatten.compact
  end

  def active_black_pieces
    all_active_pieces.keep_if { |piece| piece.color == :b}
  end

  def active_white_pieces
    all_active_pieces.keep_if { |piece| piece.color == :w}
  end


  def checked?(color)
    get_danger_zone(color).include? (kings[color].pos)
  end

  def check_mated?(color)
    dz = get_danger_zone(color)
    return true if kings[color].possible_moves.all? { |move| dz.include? move }

    #see if king can be protected by other color
    false
  end

  def move(start_pos,end_pos) # assumes color will not try to move opponents piece
    piece = find_piece_at(start_pos)
    if piece.possible_moves.include?(end_pos)# && valid_move?
      piece.pos = end_pos
      self[end_pos] = piece
      self[start_pos] = nil
    else
      raise "This piece can't move here!" 
    end

  end

  def find_piece_at(target_pos) #returns a list of active pieces if none found
    all_active_pieces.each { |piece| return piece if piece.pos == target_pos}
    raise "There is no piece there!"
  end

end

#unless $PROGRAM_NAME == __File__
#load './Chess_board.rb'; game = ChessBoard.new; game.populate_board; game.board
#end
