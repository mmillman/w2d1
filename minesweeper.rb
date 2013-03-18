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
		@blocks = Array.new(num_rows) { [:unexplored] * num_cols }
		@mines = random_mines(num_rows, num_cols, num_mines)
		add_fringe
	end

	def add_fringe
		@blocks.each_with_index do |block, index|
			if block == :mine
				p index
			end
		end
	end

	def random_mines(rows, cols, mines)
		mines_hash = Hash.new(false)
		indexes = (0...rows*cols).to_a.sample(mines)
		indexes.each do |index|
			mines_hash[[index / cols, index % cols]] = true
		end
		mines_hash
	end

	def at(x, y)

	end

	def to_s
		@blocks.map do |block|
			case block
			when :unexplored then '*'
			when :interior then '_'

		end
	end

end

class Player
	attr_reader :name

	def move(board)

	end

end