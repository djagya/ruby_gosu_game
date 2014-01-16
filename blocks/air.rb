class Air < Block
	def solid
		false
	end

	def draw
		@image[self.object_id / 100 % @image.size].draw @x, @y, 0
	end
end