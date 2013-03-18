require 'set'

class Board

	module Interior
		EMPTY = 0
		MINE = 9
		FRINGE = 1
	end

	module Exterior
		COVER = 1
		FLAG = 2
		NONE = 0
	end

	def initialize(num_rows, num_cols, num_mines)
		@num_rows, @num_cols, @num_mines = num_rows, num_cols, num_mines
		@stepped_on_mine = false
		@exterior_layer = Array.new(num_rows) { [Exterior::COVER] * num_cols }
		@interior_layer = Array.new(num_rows) { [Interior::EMPTY] * num_cols }
		@flags, @mines = Set.new, Set.new
		add_random_mines(num_rows, num_cols, num_mines)
		add_fringe
		@interior_layer.each { |row| p row }
	end

	def stepped_on_mine?
		@stepped_on_mine
	end

	def mines_sweeped?
		all_revealed? && flagged_all_mines?
	end

	def flagged_all_mines?
		@flags == @mines
	end

	def all_revealed?
		@exterior_layer.flatten.none? { |block| block == Exterior::COVER }
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
		each_neighbor(x, y) do |xo, yo|
			unless @interior_layer[xo][yo] == Interior::MINE
				@interior_layer[xo][yo] += 1
			end
		end
	end

	def each_neighbor(x, y, &proc)
		-1.upto(1) do |dx|
			-1.upto(1) do |dy|
				next if dx == 0 && dy == 0
				next unless on_board?(x + dx, y + dy)
				proc.call(x + dx, y + dy)
			end
		end
	end

	def on_board?(x, y)
		x.between?(0, @num_rows - 1) && y.between?(0, @num_cols - 1)
	end

	def reveal(x, y)
		return unless @exterior_layer[x][y] == Exterior::COVER
		@exterior_layer[x][y] = Exterior::NONE
		@stepped_on_mine = true	if @interior_layer[x][y] == Interior::MINE
		if @interior_layer[x][y] == Interior::EMPTY
			each_neighbor(x, y) { |nx, ny| reveal(nx, ny) }
		end
	end

	def toggle_flag(x, y)
		return if @exterior_layer[x][y] == Exterior::NONE
		if @exterior_layer[x][y] == Exterior::COVER
			@exterior_layer[x][y] = Exterior::FLAG
			@flags.add([x,y])
		else
			@exterior_layer[x][y] = Exterior::COVER
			@flags.delete([x,y])
		end
	end

	def add_random_mines(rows, cols, mines)
		indexes = (0...rows * cols).to_a.sample(mines)
		indexes.each do |index|
			@mines.add([index / cols, index % cols])
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
						game_board[x][y] = @interior_layer[x][y].to_s
					end
				end
			end
		end
		game_board
	end
end