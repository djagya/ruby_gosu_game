require 'gosu'
require './player'

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
	end

	def initialize
		super(WIDTH, HEIGHT, false)
		self.caption = TITLE

		@block_color = Gosu::Color.new(0xFFAA0203)
		@player = Player.new(self)
		@font = Gosu::Font.new(self, Gosu::default_font_name, 20)
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

		@player.move
	end

	def draw
		draw_background
		draw_floor
		@player.draw
		i = 1
		@player.inspect.split().each do |string|
			@font.draw(string, 10, 15*i, ZOrder::UI, 0.8, 0.8, 0xffffff00)
			i = i + 1
		end
	end

	def draw_background
		draw_quad(
				0, 0, TOP_COLOR,
				WIDTH, 0, TOP_COLOR,
				0, HEIGHT, BOTTOM_COLOR,
				WIDTH, HEIGHT, BOTTOM_COLOR,
				0)
	end

	def draw_floor
		(0..WIDTH/20).each do |i|
			draw_quad(
					i*20, HEIGHT, @block_color,
					i*20+19, HEIGHT, @block_color,
					i*20, HEIGHT-20, @block_color,
					i*20+19, HEIGHT-20, @block_color,
					0)
		end
	end
end

window = GameWindow.new
window.show