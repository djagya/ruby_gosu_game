class Player

	attr_accessor :y, :x, :vel_x, :vel_y, :on_ground, :image_key, :collide
	attr_accessor :image, :image_jump, :image_walk
	JUMP_POWER = 10
	GRAVITY = 0.5
	SPEED = 0.5
	SLOWING = 0.88
	# todo разобраться с небольшим уменьшением границ объекта
	BOUND_SCALE = 1

	PLAYER_NAME = 'danil'
	PLAYER_SIZE = {x: 30, y: 80}

	def initialize(window)
		@window_size = {width: window.width, height: window.height}
		# анимации стояния, прыжка, шага
		@image = Gosu::Image::load_tiles window, "#{__dir__}/images/players/#{PLAYER_NAME}/main.png", PLAYER_SIZE[:x], PLAYER_SIZE[:y], true
		@image_jump = Gosu::Image::load_tiles window, "#{__dir__}/images/players/#{PLAYER_NAME}/jump.png", PLAYER_SIZE[:x], PLAYER_SIZE[:y], true
		@image_walk = Gosu::Image::load_tiles window, "#{__dir__}/images/players/#{PLAYER_NAME}/walk.png", PLAYER_SIZE[:x], PLAYER_SIZE[:y], true
		# инициализация
		@y = @window_size[:height]-20
		@x = @vel_x = @vel_y = 0.0
		@on_ground = false
		@image_key = {value: 0, time: 0}
		@collide = false
	end

	def accelerate(side)
		if side == :right
			@image_key[:time] = 0 if @vel_x <= 0
			@vel_x += SPEED
		else
			@image_key[:time] = 0 if @vel_x >= 0
			@vel_x -= SPEED
		end
	end

	def jump
		if @on_ground
			@vel_y = -JUMP_POWER
			@on_ground = false
			@image_key[:time] = 0
		end
	end

	def move(blocks)
		# тянем игрока гравитацией, пока он не на земле
		unless @on_ground
			@vel_y += GRAVITY
		end

		# постепенно замедляем игрока горизонтально
		@vel_x *= SLOWING

		# сбрасываем очень маленькие значения ускорения
		if @vel_x.abs < 0.01 && @vel_x != 0
			@vel_x = 0
			@image_key[:time] = 0
		end

		# основная смена координат
		@x += @vel_x
		@y += @vel_y
		@x %= @window_size[:width]
		@y %= @window_size[:height]

		@collide = false
		blocks.each { |block| collide block if block.solid }
		@on_ground = false unless @collide
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
			@image_walk[@image_key[:value]].draw @x, @y, 1
		elsif @on_ground
			@image[@image_key[:value]].draw @x, @y, 1
		elsif !@on_ground
			@image_jump[@image_key[:value]].draw @x, @y, 1
		end

		@image_key[:time] -= 1
	end

	# @param block [Block]
	def collide(block)
		left1 = @x
		left2 = block.x
		right1 = @x + width
		right2 = block.x + block.width
		top1 = @y
		top2 = block.y
		bottom1 = @y + height
		bottom2 = block.y + block.height

		if (left1 <= right2 && left1 >= left2) && (top1 <= top2 + block.height/2 && bottom1 >= bottom2 - block.height/2)
			@collide = true

			@vel_x = 0 if @vel_x < 0
			@x = right2
		end

		if (right1 >= left2 && right1 <= right2) && (top1 <= top2 + block.height/2 && bottom1 >= bottom2 - block.height/2)
			@collide = true

			@vel_x = 0 if @vel_x > 0
			@x = left2 - width
		end

		# инвертированная операция сравнения, потому что Y на координатной сетке считается сверху вниз
		# вторая часть условия: проверяется находится ли левая, правая, центральная части игрока на блоке
		if (top1 <= bottom2 && top1 >= top2) && ((left1 >= left2 && left1 <= right2) ||
				(right1 >= left2 && right1 <= right2) ||
				(left1 + width/2 >= left2 && left1 + width/2 <= right2)
		)
			@collide = true

			@vel_y = 0 if @vel_y < 0
			@y = bottom2
		end

		if (bottom1 >= top2 && bottom1 <= bottom2) && ((left1 >= left2 && left1 <= right2) ||
				(right1 >= left2 && right1 <= right2) ||
				(left1 + width/2 >= left2 && left1 + width/2 <= right2)
		)
			@collide = true

			@vel_y = 0 if @vel_y > 0
			@y = top2 - height
			@image_key[:time] = 0 unless @on_ground
			@on_ground = true
		end
	end

	def width
		PLAYER_SIZE[:x]
	end

	def height
		PLAYER_SIZE[:y]
	end
end
