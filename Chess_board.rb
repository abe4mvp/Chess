require './Chess_piece'
class ChessBoard
  attr_accessor :board, :kings, :black_king, :white_king

  def initialize
    @board = Array.new(8) { |row| Array.new(8) { nil } }
  end

  def setup
    piece_order = [Castle,Knight,Bishop,Queen,King,Bishop,Knight,Castle]
    piece_order.each_with_index do |piece, index|
      piece.new(self, [7, index], :w)
      Pawn.new(self, [6, index], :w)
      piece.new(self, [0, index], :b)
      Pawn.new(self, [1, index], :b)
    end
    @kings = {:b => board[0,5], :w => board[7,5]}
    self.show
  end

  def populate_board
    # Queen.new(self,[7,0], :w)

    @black_king = King.new(self, [0,0], :b)
    @black_pawn1 = Pawn.new(self, [1,0], :b)
    @black_pawn1 = Pawn.new(self, [1,1], :b)
    @white_pawn1 = Pawn.new(self, [1,1], :w)
    @white_king = King.new(self, [7,7], :w)
    @kings = {:b => self.black_king, :w => self.white_king}
    Castle.new(self, [7,1], :w)
    nil
  end

  def show
    puts
    board.each do |row|
      out = "|"
      row.each do |item|
        if item.nil?
          out += "   |"
        else
          out += item.class.to_s[0..1]+item.color.to_s.upcase+ "|"
        end
      end
      puts out
      puts "-"*out.length
    end
  end




  def []=(pos, value)
    row, col = pos
    board[row][col] = value
  end

  def [](pos)
    row, col = pos
    board[row][col]
  end

  def move(start_pos,end_pos) # assumes color will not try to move opponents piece
    p start_pos
    piece = board[start_pos[0]][start_pos[1]]#refactor this line
    if piece.possible_moves.include?(end_pos) && !invalid_move?(piece, end_pos)
      piece.pos = end_pos
      self[end_pos] = piece
      self[start_pos] = nil
    else
      raise "This piece can't move here!"
    end
  end

  def dumb_move(start_pos,end_pos) #modify as version of regular move
    piece = board[start_pos[0]][start_pos[1]]#find_piece_at(start_pos)
    piece.pos = end_pos
    self[end_pos] = piece
    self[start_pos] = nil
  end

  def all_active_pieces(color) #refctor to take optional block?
    board.flatten.compact.keep_if { |piece| piece.color == color}
  end
  #
  # def active_black_pieces
  #   all_active_pieces.keep_if { |piece| piece.color == :b}
  # end
  #
  # def active_white_pieces
  #   all_active_pieces.keep_if { |piece| piece.color == :w}
  # end


  def checked?(color)
    enemy_strike_zone(color).include? (kings[color].pos)
  end

  def check_mated?(color)
    strike_zone = enemy_strike_zone(color)
    return false unless kings[color].possible_moves.all? { |move| strike_zone.include? move }
    #use as a shortcut to break from checkmate if king can escape
    #(place in seperate method)

    enemy = color == :w ? :b : :w
    pieces = all_active_pieces(color)
    p pieces
    pieces.each do |piece|
      return false unless piece.possible_moves.all? { |move| invalid_move?(piece, move)  }
    end

    true
  end

  private

  def invalid_move?(piece, destination)
    test_board = Marshal.load(Marshal.dump(self))
    test_board.dumb_move(piece.pos, destination)
    test_board.checked?(piece.color)
  end

  def enemy_strike_zone(color)# REFACTOR!
    strike_zone = []
    enemy_color = color == :w ? :b : :w

    all_active_pieces(enemy_color).each do |piece|
      strike_zone += piece.possible_moves #if piece.color == enemy_color
    end

    strike_zone
  end

  def find_piece_at(target_pos) #refactor
    #fix by adjusting all active piece call
    all_active_pieces.each { |piece| return piece if piece.pos == target_pos}
    raise "There is no piece there!"
  end
end

#unless $PROGRAM_NAME == __File__
#load './Chess_board.rb'; game = ChessBoard.new; game.populate_board; game.board
#end
