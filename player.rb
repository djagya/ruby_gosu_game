class Player

	attr_accessor :vel_x, :vel_y, :on_ground, :y, :x, :color
	JUMP_POWER = 10
	GRAVITY = 0.35

	def initialize(window)
		@window = window
		@image = Gosu::Image::load_tiles window, "#{__dir__}/images/players/danil.png", 30, 80, true
		@y = @window.height-20
		@x = @vel_x = @vel_y = 0.0
		@on_ground = true
		@image_key = {value: 0, time: 0}
	end

	def accelerate(side)
		if side == :right
			@vel_x += Gosu::offset_x(90, 0.5)
		else
			@vel_x -= Gosu::offset_x(90, 0.5)
		end
	end

	def jump
		if @on_ground
			@vel_y = -Gosu::offset_y(180, JUMP_POWER)
			@on_ground = false
			@image_key[:time] = 0
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
		if @image_key[:time] <= 0
			@image_key[:value] = @on_ground ? rand(4) : 7-rand(4)
			@image_key[:time] = rand(300)
		end
		@image[@image_key[:value]].draw @x, @y-80, 1
		@image_key[:time] -= 1
	end
end
