local LightModule = {}

local LightBeam = {
	stepDirLookup = {
		left = {x = -1, y =  0},
		up   = {x =  0, y = -1},
		right= {x =  1, y =  0},
		down = {x =  0, y =  1}
	}
}

local LightBeam_mt = {__index = LightBeam}

function LightBeam.shine(self)
	-- setup
	local emit = {x = self.x, y = self.y}
	local emitDir = self.initDir
	love.graphics.setLineWidth(0.5 * self.parent.width / self.parent.rows)
	love.graphics.setColor(255, 255, 255, 128)
	local collision
	-- while light is still cast, get the next change in direction location
	while emit do
		-- cast until collide
		local collision = self:findColl(emit, emitDir)
		if collision == nil then
			break
		end
		-- draw
		self:drawBeam(emit, collision, emitDir)
		-- change state
		emit = collision
		emitDir = "up"
	end
	love.graphics.setLineWidth(1)
	love.graphics.setColor(255, 255, 255, 255)
	-- TODO
end

function LightBeam.findColl(self, emit, emitDir)
	-- TODO: Try to collide with objects first
	local step = self.stepDirLookup[emitDir]
	local current = {x = emit.x, y = emit.y}
	if  current.x + step.x >= self.parent.rows
		or current.x + step.x <= -1
		or current.y + step.y >= self.parent.cols
		or current.y + step.y  <= -1
	then
		return nil
	end
	-- While the current square is on the grid
	while   current.x < self.parent.rows
		and current.x >= 0
		and current.y < self.parent.cols
		and current.y >= 0
	do
		-- Collide with stuff
		-- Return early
		-- Update current
		current.x = current.x + step.x
		current.y = current.y + step.y
	end
	-- step back one because we left the grid
	current.x = current.x - step.x
	current.y = current.y - step.y
	return current
end

function LightBeam.drawBeam(self, emit, collision, dir)
	-- global location variables
	local origin = {x = self.parent.x, y = self.parent.y}
	local cellDim = self.parent.width / self.parent.rows
	-- calculate centers of "lit" squares
	local start = {x = origin.x + cellDim * (emit.x + .5), y = origin.y + cellDim * (emit.y + .5)}
	local finish = {x = origin.x + cellDim * (collision.x + .5), y = origin.y + cellDim * (collision.y + .5)}
	-- draw
	love.graphics.line(start.x, start.y, finish.x, finish.y)
end

function LightBeam.ctor(self, parentGrid, startXCoord, startYCoord, direction)
	local newBeam = {x = startXCoord, y = startYCoord, initDir = direction, parent = parentGrid}
	setmetatable(newBeam, LightBeam_mt)
	return newBeam
end

local LightBeam_cmt = {__call = LightBeam.ctor}

setmetatable(LightBeam, LightBeam_cmt)

LightModule.LightBeam = LightBeam

return LightModule