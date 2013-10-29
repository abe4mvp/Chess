# Assumptions
# => White is on the bottom of the board (high indexes)
# => White moves first
#

class Piece
  attr_accessor :board, :pos, :player
  BOARD_RANGE = (0..7).to_a
  CARDINAL_DELTA = [[0,1], [1,0], [-1,0], [0,-1]]
  DIAG_DELTA = [[1,1], [-1,-1], [1,-1], [-1,1]]
  COMP_DELTA = CARDINAL_DELTA + DIAG_DELTA
  def initialize(board = nil, pos, player)# player = :b/:w
    @board, @pos, @player = board, pos, player
  end

  def on_board?(move)
    move.all? { |coord| BOARD_RANGE.include?(coord) }
  end

  def inspect
    p self.class.to_s[0..1]
  end

  # def check_spot(move)
#     self.board[move[0]][move[1]]
#   end
end



class SlidingPiece < Piece

  def possible_slides(deltas)
    moves = []
    deltas.each do |delta|
      potential_move = [(pos[0]+ delta[0]),(pos[1] + delta[1])]
      next unless on_board?(potential_move)
      target = board[potential_move]
      #potential move format [x,y]
      while (target.nil? || target.player != self.player) && on_board?(potential_move)
        moves << potential_move.dup
        if (target != nil && target.player != self.player)
          puts "DAMNIT!"
          break
        end
        potential_move[0] += delta[0]
        potential_move[1] += delta[1]
        target = board[potential_move]
      end
    end

    moves
  end



  # increments = (-7..7).to_a*2
  # increments.permutation(2).to_a.keep_if {|x, y| x.abs == y.abs }.uniq


  # def diagonal_moves
 #    moves = []
 #    (1..7).each do |increment|
 #      moves << [(pos[0] + increment),(pos[1]+ increment)]
 #      moves << [(pos[0] - increment),(pos[1] + increment)]
 #      moves << [(pos[0] + increment),(pos[1] - increment)]
 #      moves << [(pos[0] - increment),(pos[1] - increment)]
 #    end
 #    moves.keep_if { |move| on_board?(move) }
 #  end

end

class Castle < SlidingPiece
  def possible_moves
    possible_slides(CARDINAL_DELTA)
  end
end

class Bishop < SlidingPiece
  def possible_moves
    possible_slides(DIAG_DELTA)
  end
end

class Queen < SlidingPiece
  def possible_moves
    possible_slides(COMP_DELTA)
  end
end

class Pawn < Piece
  attr_accessor :moved

  def initialize(board, pos, player)
    super(board, pos, player)
    @moved = false # move to main class if castling
  end

  def possible_moves
    regular_move + double_move + kill_move
  end

  def regular_move
    player == :w ? [[(pos[0] + 1),(pos[1])]] : [[(pos[0] - 1),(pos[1])]]
  end

  def double_move
    return [] if moved
    moved = true
    player == :w ? [[(pos[0] + 2),(pos[1])]] : [[(pos[0] - 2),(pos[1])]]
  end

  def kill_move
    if player == :w
      [[(pos[0]-1),(pos[1]+1)],[(pos[0]-1),(pos[1]-1)]] #white pawn
    else
      [[(pos[0]+1),(pos[1]+1)],[(pos[0]+1),(pos[1]-1)]] #black pawn
    end
  end

end

class SteppingPiece < Piece
  def in_range_moves(deltas) #possibly move to main class if needed
    deltas.map { |x, y| [self.pos[0]+x, self.pos[1]+y] }.keep_if do |move|
      on_board?(move)
    end
  end

end

class Knight < SteppingPiece
  KNIGHT_DELTA = [1,2,-1,-2].permutation(2).to_a.keep_if {|x,y| x != -y }

  def possible_moves
    in_range_moves(KNIGHT_DELTA)#narrow to moves that are legal
  end

end

class King < SteppingPiece

  def possible_moves
    in_range_moves(COMP_DELTA)
  end

end