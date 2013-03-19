require './board'
require './highscore'
require './player'
require 'yaml'

class Minesweeper

	MODES = {:easy => [9, 9, 10], :hard => [16, 16, 40]}

	def self.new_game(mode = :easy)
		mode = :easy unless MODES.has_key?(mode)
		rows, cols, mines = MODES[mode]
		self.new(Board.new(rows, cols, mines, mode))
	end

	def self.load_game
		board = YAML.load(File.open("minesweeper.save"))
		self.new(board)
	end

	def play(player)
		until game_over?
			command, x, y = player.move(@board.game_board, @board.seconds_elapsed)
			exec_command(command, player, x, y)
		end

		player.blow_up(@board.game_board) if @board.stepped_on_mine?
		if @board.mines_sweeped?
			player.victory(@board.game_board)
			update_high_score(@board.mode, @board.seconds_elapsed, player.name)
		end
		player.display_high_score(load_high_score(@board.mode))
	end

	def exec_command(command, player, x, y)
		case command
		when nil then return
		when :reveal then @board.reveal(x, y)
		when :flag then @board.toggle_flag(x, y)
		when :highscore then player.display_high_score(load_high_score(@board.mode))
		when :save then save_game
		when :quit then exit
		end
	end

	def game_over?
		@board.stepped_on_mine? || @board.mines_sweeped?
	end

	def save_game
		File.open("minesweeper.save", 'w') { |file| file.write(@board.to_yaml) }
	end

	def update_high_score(mode, seconds, player_name)
		filename = "minesweeper-scores-#{mode.to_s}.yaml"
		if File.exists?(filename)
			scores = YAML.load(File.open(filename))
		else
		 	scores = HighScore.new
	 	end
		scores.insert_score(seconds, player_name)
		File.open(filename, 'w') { |file| file.write(scores.to_yaml) }
	end

	def load_high_score(mode)
		filename = "minesweeper-scores-#{mode.to_s}.yaml"
		if File.exists?(filename)
			YAML.load(File.open(filename)).top_ten
		else
		 	[]
	 	end
	end

	protected
	def initialize(board)
		@board = board
	end

end

Minesweeper.new_game(:hard).play(Player.new("Mark"))