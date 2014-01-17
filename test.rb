require 'gosu'
require_relative 'debug'
require_relative 'player'
require_relative 'block'

module ZOrder
	Background, Stars, Player, UI = *0..3
end

class GameWindow < Gosu::Window
	WIDTH = 640
	HEIGHT = 480
	TITLE = "Test"

	TOP_COLOR = Gosu::Color.new(0xFF000000)
	BOTTOM_COLOR = Gosu::Color.new(0xFF000000)

	def button_down(id)
		if id == Gosu::KbEscape
			close
		end
		if id == Gosu::KbR
			@player = Player.new(self)
		end
	end

	def initialize
		super(WIDTH, HEIGHT, false)
		self.caption = TITLE

		@player = Player.new(self)
		@blocks = []
		@debug = Debug.new(self)
		init_blocks
	end

	def init_blocks
		map = File.open __dir__ + '/map.dat', 'r'

		i = j =0
		map.each_line do |line|
			line.strip!
			line.each_char do |char|
				block = Block.create(self, char, j, i)
				@blocks.push block
				j += 1
			end
			j = 0
			i += 1
		end
	end

	def update
		if button_down? Gosu::KbRight
			@player.accelerate :right
		end
		if button_down? Gosu::KbLeft
			@player.accelerate :left
		end
		if button_down? Gosu::KbUp
			@player.jump
		end

		@player.move @blocks
	end

	def draw
		draw_background
		@debug.draw_debug @player
		@player.draw
		@blocks.each { |block| block.draw }
	end

	def draw_background
		draw_quad(
				0, 0, TOP_COLOR,
				WIDTH, 0, TOP_COLOR,
				0, HEIGHT, BOTTOM_COLOR,
				WIDTH, HEIGHT, BOTTOM_COLOR,
				0)
	end
end

window = GameWindow.new
window.show