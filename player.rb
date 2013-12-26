class Player

	JUMP_POWER = 10
	GRAVITY = 0.2

	def initialize(window)
		@window = window
		@color = Gosu::Color.new(0xFF00AAF4)
		@y = @window.height-20
		@x = @vel_x = @vel_y = 0.0
		@angle = 90.0
		@on_ground = true
	end

	def accelerate(side)
		if side == :right
			@vel_x += Gosu::offset_x(@angle, 0.5)
			@vel_y += Gosu::offset_y(@angle, 0.5)
		else
			@vel_x -= Gosu::offset_x(@angle, 0.5)
			@vel_y -= Gosu::offset_y(@angle, 0.5)
		end
	end

	def jump
		if @on_ground
			@vel_y = -Gosu::offset_y(180, JUMP_POWER)
			@on_ground = false
		end
	end

	def move
		unless @on_ground
			@vel_y += Gosu::offset_y(180, GRAVITY)
		end

		@x += @vel_x
		@y += @vel_y
		@x %= @window.width
		@y %= @window.height

		if @y >= @window.height-20
			@on_ground = true
			@vel_y = 0
		end

		@vel_y = 0 if @vel_y.abs < 0.01
		@vel_x = 0 if @vel_x.abs < 0.01

		@vel_x *= 0.95
		@vel_y *= 0.95
	end

	def draw
		@window.draw_triangle(@x, @y, @color, @x, @y-20, @color, @x+20, @y, @color)
	end
end
