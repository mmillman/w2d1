class Minesweeper

	def initialize(rows, cols, mines)
		@board = Board.new(rows, cols, mines)
		puts @board
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
	module Interior
		EMPTY = 0
		MINE = 9
		FRINGE = 1
	end

	module Exterior
		COVER = 1
		FLAG = 2
		EMPTY = 0
	end

	def initialize(num_rows, num_cols, num_mines)
		@num_rows, @num_cols = num_rows, num_cols
		# cover layer can have :cover, :flag or nil
		@exterior_layer = Array.new(num_rows) { [Exterior::COVER] * num_cols }
		# hidden layer can have fringes (:1-:8), and :mine
		@interior_layer = Array.new(num_rows) { [Interior::EMPTY] * num_cols }

		add_random_mines(num_rows, num_cols, num_mines)
		add_fringe
		@interior_layer.each {|row| p row}
	end

	def add_fringe
		@interior_layer.each_with_index do |row, i|
			row.each_with_index do |block, j|
				if block == Interior::MINE
					increment_fringe(i, j)
				end
			end
		end
	end

	def increment_fringe(x, y)
		-1.upto(1) do |x_offset|
			-1.upto(1) do |y_offset|
				next unless (x + x_offset).between?(0, @num_rows - 1) &&
						(y + y_offset).between?(0, @num_cols - 1)
				unless @interior_layer[x + x_offset][y + y_offset] == Interior::MINE
					@interior_layer[x + x_offset][y + y_offset] += 1
				end
			end
		end
	end

	def add_random_mines(rows, cols, mines)
		indexes = (0...rows * cols).to_a.sample(mines)
		indexes.each do |index|
			@interior_layer[index / cols][index % cols] = Interior::MINE
		end
	end

	def at(x, y)

	end

	def public_board

	end

end

class Player
	attr_reader :name

	def move(board)

	end

end

Minesweeper.new(9, 9, 10)