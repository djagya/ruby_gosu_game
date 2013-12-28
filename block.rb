class Block

	BLOCK_SIZE = 20
	BLOCK_TYPES = {
			brick: '#',
			air: '.',
	}

	def initialize(window, type_char, x_num, y_num)
		@window = window
		@type = BLOCK_TYPES.index type_char

		@color = Gosu::Color.new(0xFFAAFF03)

		@x = x_num * BLOCK_SIZE
		@y = y_num * BLOCK_SIZE
	end

	def draw
		@window.draw_quad(
				@x, @y, @color,
				@x+BLOCK_SIZE-1, @y, @color,
				@x, @y+BLOCK_SIZE-1, @color,
				@x+BLOCK_SIZE-1, @y+BLOCK_SIZE-1, @color,
				0) if @type == :brick
	end
end