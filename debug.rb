class Debug
	def initialize(window)
		@window_size = {width: window.width, height: window.height}
		@font = Gosu::Font.new(window, Gosu::default_font_name, 20)
	end

	def draw_debug(*args)
		i = 0
		j = 1
		args.each.inspect.split().each do |string|
			unless string.include? 'Image'
				if i*20 > @window_size[:height]
					j = 30
					i = 0
				end
				@font.draw(string, 10*j, 15*i, ZOrder::UI, 0.8, 0.8, 0xffffff00)
				i = i + 1
			end
		end
	end
end