Kuroko = {
	x = 0,
	y = 0,
	w = 100,
	h = 100,
	collide = function(self, cx, cy)
		return (cx - self.x < self.w) and (cy - self.y < self.h)
	end,

	draw = function(self)
		love.graphics.draw(kuroko, self.x, self.y)
	end
};

function love.load()
   kuroko = love.graphics.newImage("images/kuroko.png")
   x = 100
   y = 100
   Kuroko.w = kuroko:getWidth()
   Kuroko.h = kuroko:getHeight()
end

function love.draw()
   --love.graphics.draw(kuroko, Kuroko.x, Kuroko.y)
   Kuroko:draw()
	 if( Kuroko:collide(love.mouse.getX(), love.mouse.getY()) )
	 then
		-- Kuroko:draw()
	 end

end

function love.mousepressed(x, y, button)
  if( Kuroko:collide(x, y))
	then
		 Kuroko.grabbed = true
		 Kuroko.grabX = x
		 Kuroko.grabY = y
	end
end

function love.mousereleased(x, y, button)
	Kuroko.x = Kuroko.x + x - Kuroko.grabX
	Kuroko.y = Kuroko.y + y - Kuroko.grabY
	Kuroko.grabbed = false
end
