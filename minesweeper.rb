class Minesweeper

	def initialize(rows, cols, mines)
	end

	def play(player)
		until game_over?
			move = player.move(board)
			board.make_move(move)
		end
	end

	def game_over?

	end

end

class Board

	def initialize(num_rows, num_cols, num_mines)
		@num_rows, @num_cols = num_rows, num_cols
		@blocks = Array.new(num_rows * num_cols) { :unexplored }
		num_mines.times { |index| @blocks[index] = :mine }
		@blocks.shuffle
		add_fringe
		@flags = {}
	end

	def add_fringe
		@blocks.each_with_index do |block, index|
			if block == :mine
				p index
			end
		end
	end

	def at(x, y)

	end

	def to_s
		@blocks.map do |block|

		end
	end

end

class Player
	attr_reader :name

	def move(board)

	end

end