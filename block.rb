class Block

	BLOCK_SIZE = 20
	BLOCK_TYPES = {
			brick: '#',
			air: '.',
	}

	class << self
		attr_accessor :image

		# метод-фабрика, возвращает новый класс с нужным типом
		def create(window, type_char, x_num, y_num)
			type = BLOCK_TYPES.key(type_char)
			if type
				type = type.to_s.capitalize
				Object.const_get(type).new(window, x_num, y_num)
			else
				raise "Bad block type #{type_char}"
			end
		end
	end

	def initialize(window, x_num, y_num)
		@window = window

		load_image

		@x = x_num * BLOCK_SIZE
		@y = y_num * BLOCK_SIZE
	end

	def draw
		@image[(Gosu::milliseconds + self.object_id) / 100 % @image.size].draw @x, @y, 0
	end

	def load_image
		@image ||= Gosu::Image::load_tiles @window, "#{__dir__}/images/blocks/#{self.class.to_s.downcase}.png", BLOCK_SIZE, BLOCK_SIZE, true
	end
end

Dir["#{__dir__}/blocks/*.rb"].each { |file| require file }