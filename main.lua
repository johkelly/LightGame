Kuroko = {
	x = 0,
	y = 0,
	w = 100,
	h = 100,
	collide = function(self, cx, cy)
		return (cx - self.x < self.w) and (cy - self.y < self.h)
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
   love.graphics.draw(kuroko, Kuroko.x, Kuroko.y)
   print( Kuroko:collide(love.mouse.getX(), love.mouse.getY()) )
end
