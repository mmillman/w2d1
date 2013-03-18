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
		@exterior_layer = Array.new(num_rows) { [Exterior::COVER] * num_cols }
		@interior_layer = Array.new(num_rows) { [Interior::EMPTY] * num_cols }
		add_random_mines(num_rows, num_cols, num_mines)
		add_fringe
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

	def game_board
		game_board = Array.new(@num_rows) {[]}
		(0...@num_rows).each do |x|
			(0...@num_rows).each do |y|
				case @exterior_layer[x][y]
				when Exterior::COVER then game_board[x][y] = '*'
				when Exterior::FLAG then game_board[x][y] = 'F'
				else
					case @interior_layer[x][y]
					when Interior::EMPTY then game_board[x][y] = '_'
					when Interior::MINE then game_board[x][y] = 'X'
					else
						@interior_layer[x][y]
					end
				end
			end
		end
		game_board
	end
end