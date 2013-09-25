function love.load()
	love.graphics.setMode(600, 600)
	GridModule = require("gridspace_module")
	MouseGrabStack = require("mousegrab_module")
	board = GridModule.GridContainer(25, 30, 550, 440, 5, 4)
	itembox = GridModule.GridContainer(25, 500, 550, 90, 5, 2)
	kuroko = love.graphics.newImage("images/kuroko.png")
	GO_Kuroko = GridModule.GridObject(kuroko)
	itembox:putObject(GO_Kuroko, 0, 0)
end

function love.draw()
	board:draw()
	itembox:draw()
	MouseGrabStack.draw()
end

function love.mousepressed(x, y, button)
	area = (y > board.height) and itembox or board

	grabbed = area:pickObject(x, y)
	area:removeObjectAt(x, y)

	MouseGrabStack.grab(grabbed, x, y)
end

function love.update(dt)
	-- pass
end

function love.mousereleased(x, y, button)
	local released, grabX, grabY = MouseGrabStack.release()
	if released then
		board:snapObjectAt(released, love.mouse.getX(), love.mouse.getY()) 
	end
end

function love.keypressed(key, isrepeat)
	if key == "escape" then
		love.event.push("quit")
	end
end
