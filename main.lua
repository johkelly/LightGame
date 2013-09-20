Kuroko = {
	x = 0,
	y = 0,
	w = 100,
	h = 100,

	dragging = {
		grabbed = false,
		grabX = 0,
		grabY = 0
	},

	collide = function(self, cx, cy)
		return (cx - self.x < self.w) and (cy - self.y < self.h)
	end,

	draw = function(self)
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
		love.graphics.draw(kuroko, self.x, self.y)
	end
};

function love.load()
	GridModule = require("gridspace_module")
	foo = GridModule.GridContainer(10, 10, 500, 500, 3, 3)
	foo:putObject(Kuroko, 1, 0)
	foo:getObjects(1, 0)
	foo:removeObject(Kuroko, 1, 0)
	kuroko = love.graphics.newImage("images/kuroko.png")
	x = 100
	y = 100
	Kuroko.w = kuroko:getWidth()
	Kuroko.h = kuroko:getHeight()
end

function love.draw()
	--love.graphics.draw(kuroko, Kuroko.x, Kuroko.y)
	-- Kuroko:draw()
	foo:draw()
	--[[
	if( Kuroko:collide(love.mouse.getX(), love.mouse.getY()) )
	then
	-- Kuroko:draw()
	end
	]]
end

function love.mousepressed(x, y, button)
	if( Kuroko:collide(x, y))
	then
		Kuroko.dragging.grabbed = true
		Kuroko.dragging.grabX = x - Kuroko.x
		Kuroko.dragging.grabY = y - Kuroko.y
	end
end

function love.update(dt)
	if(Kuroko.dragging.grabbed)
	then
		Kuroko.x = love.mouse.getX() - Kuroko.dragging.grabX
		Kuroko.y = love.mouse.getY() - Kuroko.dragging.grabY
	end
end

function love.mousereleased(x, y, button)
	Kuroko.dragging.grabbed= false
	foo:snapObject(Kuroko)
end

function love.keypressed(key, isrepeat)
	if key == "escape" then
		love.event.push("quit")
	end
end
