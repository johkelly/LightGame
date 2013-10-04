function love.load()
	love.graphics.setMode(600, 500)
	GridModule = require("gridspace_module")
	MouseGrabStack = require("mousegrab_module")
	LightModule = require("lightbeam_module")
	foo = GridModule.GridContainer(25, 30, 550, 440, 5, 4)
	kuroko = love.graphics.newImage("images/kuroko.png")
	GO_Kuroko = GridModule.GridObject(kuroko)
	GO_Kuroko.objType = "reflect_right"
	foo:putObject(GO_Kuroko, 0, 1)
	lightbeam = LightModule.LightBeam(foo, 0, 3, "up")
end

function love.draw()
	lightbeam:shine()
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
