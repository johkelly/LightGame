local MouseGrab = {}

MouseGrab.grabIndex = 0
MouseGrab.grabStack = {} -- TODO: Make a proper stack

-- Add a triple: (Object, GrabbedAtX, GrabbedAtY)
function MouseGrab.grab(target, x, y)
	local grabtriple = {t = target, x = x, y = y}
	MouseGrab.grabbed = target
	MouseGrab.grabX = x
	MouseGrab.grabY = y
end

function MouseGrab.release()
	local ret = MouseGrab.grabbed
	MouseGrab.grabbed = nil
	return ret, MouseGrab.grabX, MouseGrab.grabY
end

function MouseGrab.draw()
	if MouseGrab.grabbed then
		local dx = love.mouse.getX() - MouseGrab.grabX
		local dy = love.mouse.getY() - MouseGrab.grabY
		MouseGrab.grabbed:drawOffset(dx, dy)
	end
end

return MouseGrab