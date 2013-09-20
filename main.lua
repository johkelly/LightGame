function love.load()
	love.graphics.setMode(600, 500)
	GridModule = require("gridspace_module")
	MouseGrabStack = require("mousegrab_module")
	foo = GridModule.GridContainer(25, 30, 550, 440, 5, 4)
	kuroko = love.graphics.newImage("images/kuroko.png")
	GO_Kuroko = GridModule.GridObject(kuroko)
	foo:putObject(GO_Kuroko, 0, 1)
end

function love.draw()
	--love.graphics.draw(kuroko, Kuroko.x, Kuroko.y)
	-- Kuroko:draw()
	foo:draw()
	MouseGrabStack.draw()
	--GO_Kuroko:drawFill(10, 10, 100, 100)
	--[[
	if( Kuroko:collide(love.mouse.getX(), love.mouse.getY()) )
	then
	-- Kuroko:draw()
	end
	]]
end

function love.mousepressed(x, y, button)
	grabbed = foo:pickObject(x, y)
	foo:removeObject(x, y)
	MouseGrabStack.grab(grabbed, x, y)
	--	if( Kuroko:collide(x, y))
	--	then
	--		Kuroko.dragging.grabbed = true
	--		Kuroko.dragging.grabX = x - Kuroko.x
	--		Kuroko.dragging.grabY = y - Kuroko.y
	--	end
end

function love.update(dt)
--	if(Kuroko.dragging.grabbed)
--	then
--		Kuroko.x = love.mouse.getX() - Kuroko.dragging.grabX
--		Kuroko.y = love.mouse.getY() - Kuroko.dragging.grabY
--	end
end

function love.mousereleased(x, y, button)
	local released, grabX, grabY = MouseGrabStack.release()
	if released then
		foo:snapObjectAt(released, love.mouse.getX(), love.mouse.getY()) 
	end
	--	Kuroko.dragging.grabbed= false
	--	foo:snapObject(Kuroko)
end

function love.keypressed(key, isrepeat)
	if key == "escape" then
		love.event.push("quit")
	end
end
