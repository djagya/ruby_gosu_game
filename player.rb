class Player

	attr_accessor :y, :x, :vel_x, :vel_y, :on_ground, :image_key
	attr_accessor :image, :image_jump, :image_walk
	JUMP_POWER = 10
	GRAVITY = 0.35

	PLAYER_NAME = 'danil'
	PLAYER_SIZE = {x: 30, y: 80}

	def initialize(window)
		@window_size = {width: window.width, height: window.height}
		@image = Gosu::Image::load_tiles window, "#{__dir__}/images/players/#{PLAYER_NAME}/main.png", PLAYER_SIZE[:x], PLAYER_SIZE[:y], true
		@image_jump = Gosu::Image::load_tiles window, "#{__dir__}/images/players/#{PLAYER_NAME}/jump.png", PLAYER_SIZE[:x], PLAYER_SIZE[:y], true
		@image_walk = Gosu::Image::load_tiles window, "#{__dir__}/images/players/#{PLAYER_NAME}/walk.png", PLAYER_SIZE[:x], PLAYER_SIZE[:y], true
		@y = @window_size[:height]-20
		@x = @vel_x = @vel_y = 0.0
		@on_ground = true
		@image_key = {value: 0, time: 0}
		@font = Gosu::Font.new(window, Gosu::default_font_name, 20)
	end

	def accelerate(side)
		if side == :right
			@image_key[:time] = 0 if @vel_x <= 0
			@vel_x += Gosu::offset_x(90, 0.5)
		else
			@image_key[:time] = 0 if @vel_x >= 0
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
		@x %= @window_size[:width]
		@y %= @window_size[:height]

		if @y >= @window_size[:height]-20 && !@on_ground
			@on_ground = true
			@vel_y = 0
			@image_key[:time] = 0
		end

		if @vel_x.abs < 0.01 && @vel_x != 0
			@vel_x = 0
			@image_key[:time] = 0
		end

		@vel_x *= 0.90
	end

	def draw
		if @image_key[:time] <= 0
			if @on_ground && @vel_x != 0
				if @vel_x < 0
					@image_key[:value] = (@image_key[:value] + 1) % (@image_walk.size / 2)
				elsif @vel_x > 0
					@image_key[:value] = (@image_walk.size / 2) + (@image_key[:value] + 1) % (@image_walk.size / 2)
				end
				@image_key[:time] = 10
			elsif @on_ground
				@image_key[:value] = rand(@image.size-1)
				@image_key[:time] = 50 + rand(150)
			elsif !@on_ground
				@image_key[:value] = rand(@image_jump.size-1)
				@image_key[:time] = 50 + rand(150)
			end
		end

		if @on_ground && @vel_x != 0
			@image_walk[@image_key[:value]].draw @x, @y-PLAYER_SIZE[:y], 1
		elsif @on_ground
			@image[@image_key[:value]].draw @x, @y-80, 1
		elsif !@on_ground
			@image_jump[@image_key[:value]].draw @x, @y-80, 1
		end

		@image_key[:time] -= 1

		draw_debug
	end

	def draw_debug
		i = 0
		j = 1
		self.inspect.split().each do |string|
			if i*20 > @window_size[:height]
				j = 30
				i = 0
			end
			@font.draw(string, 10*j, 15*i, ZOrder::UI, 0.8, 0.8, 0xffffff00)
			i = i + 1
		end
	end
end
