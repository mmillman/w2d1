require './board'
require 'yaml'

class Minesweeper

	MODES = {:easy => [9, 9, 1], :hard => [16, 16, 40]}

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

class Player
	attr_reader :name

	VALID_COMMANDS = {'f' => :flag, 'r' => :reveal, 's' => :save, 'q' => :quit, 'hs' => :highscore }

	def initialize(name)
		@name = name
	end

	def move(board, seconds)
		print_board(board)
		puts "time: #{seconds.to_i}s. 'r x y' to reveal, 'f x y' to flag, hs for high scores, s to save, q to quit"
		input = gets.chomp.split(' ')

		return nil unless VALID_COMMANDS.include?(input[0])
		return VALID_COMMANDS[input[0].downcase], input[1].to_i, input[2].to_i
	end

	def blow_up(board)
		print_board(board)
		puts "u dead"
	end

	def print_board(board)
		puts "     " + 0.upto(board[0].length - 1).map { |i| i.to_s.rjust(2)}.join(' ')
		puts "    " + "-" * board[0].length * 3 + "--"

		board.each_with_index { |row, index| puts " #{index.to_s.rjust(2)} | " + row.join('  ') + " |" }

		puts "    " + "-" * board[0].length * 3 + "--"
	end

	def victory(board)
		print_board(board)
		puts "u win"
	end

	def update_timer(seconds)
		p seconds
	end

	def display_high_score(scores)
		print "high score: "
		p scores
	end

end

class HighScore
	def initialize
		@high_scores = []
	end

	def top_ten
		@high_scores
	end

	def insert_score(seconds, player_name)
		@high_scores << [seconds, player_name]
		@high_scores.sort! { |s1, s2| s1.first <=> s2.first }
		while @high_scores.length > 10
			@high_scores.pop
		end
	end
end

Minesweeper.new_game(:hard).play(Player.new("Mark"))