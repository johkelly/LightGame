function love.load()
	love.graphics.setMode(600, 600)
	GridModule = require("gridspace_module")
	MouseGrabStack = require("mousegrab_module")
	board = GridModule.GridContainer(25, 30, 550, 440, 5, 4)
	itembox = GridModule.GridContainer(25, 500, 550, 90, 5, 2)
	for line in love.filesystem.lines("objects.dat") do
		tempObj = love.graphics.newImage("images/"..line)
		GO_tempObj = GridModule.GridObject(tempObj)
		itembox:putObject(GO_tempObj,itembox:getFirstEmptySpace())
	end	
end

function love.draw()
	board:draw()
	itembox:draw()
	MouseGrabStack.draw()
end

function getGridAt(y)
	return ((board:inGrid(y)) and board or itembox)
end

function love.mousepressed(x, y, button)
	grid = getGridAt(y)

	if button == "l"
	then
		grabbed = grid:pickObject(x, y)

		if grabbed == nil
		then 
			return
		end

		MouseGrabStack.grab(grabbed, x, y)
		grid:removeObjectAt(x, y)
	end
end

function love.update(dt)
	-- pass
end

function love.mousereleased(x, y, button)
	grid = getGridAt(y)

	if button == "l"
	then
		local released, grabX, grabY = MouseGrabStack.release()
		if released then
			grid:snapObjectAt(released, love.mouse.getX(), love.mouse.getY()) 
		end
	end
end

function love.keypressed(key, isrepeat)
	if key == "escape" then
		love.event.push("quit")
	end
end
