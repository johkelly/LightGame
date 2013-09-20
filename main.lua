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
	foo:draw()
	MouseGrabStack.draw()
end

function love.mousepressed(x, y, button)
	grabbed = foo:pickObject(x, y)
	foo:removeObjectAt(x, y)
	MouseGrabStack.grab(grabbed, x, y)
end

function love.update(dt)
	-- pass
end

function love.mousereleased(x, y, button)
	local released, grabX, grabY = MouseGrabStack.release()
	if released then
		foo:snapObjectAt(released, love.mouse.getX(), love.mouse.getY()) 
	end
end

function love.keypressed(key, isrepeat)
	if key == "escape" then
		love.event.push("quit")
	end
end
