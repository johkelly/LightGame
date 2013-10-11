local LightModule = {}

local LightBeam = {
	stepDirLookup = {
		left = {x = -1, y =  0},
		up   = {x =  0, y = -1},
		right= {x =  1, y =  0},
		down = {x =  0, y =  1}
	},
	reflectDirLookup = {
		left = {
			reflect_right = "down",
			reflect_left = "up"
		},
		up = {
			reflect_right = "right",
			reflect_left = "left"
		},
		right = {
			reflect_right = "up",
			reflect_left = "down"
		},
		down = {
			reflect_right = "left",
			reflect_left = "right"
		}
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
		local collision, object = self:findColl(emit, emitDir)
		-- TODO: Collect extra beams in a table and cast/draw
		if collision == nil then
			break
		end
		-- draw
		self:drawBeam(emit, collision, emitDir)
		-- change state
		emit = collision
		--if type == "reflect_right" then emitDir = "right" end
		emit, emitDir = self:reactToObject(collision, emitDir, object)
	end
	love.graphics.setLineWidth(1)
	love.graphics.setColor(255, 255, 255, 255)
	-- TODO
end

function LightBeam.reactToObject(self, collision, approachDir, object)
	if not object then
		return nil, "edge"
	end
	return object:react(collision, approachDir)
end

function LightBeam.findColl(self, emit, emitDir)
	-- TODO: Try to collide with objects first
	local step = self.stepDirLookup[emitDir]
	local current = {x = emit.x, y = emit.y}
	if  self:leavingGrid(emit, step)
	then
		return nil
	end
	-- While the current square is on the grid
	while   self:inGrid(current)
	do
		-- Update current
		self.step(current, step)
		-- Collide with stuff
		local object = self.parent:getObject(current.x, current.y)
		if object then
			-- Return early
			return current, object
		end
	end
	-- step back one because we left the grid
	current.x = current.x - step.x
	current.y = current.y - step.y
	return current, nil
end

function LightBeam.leavingGrid(self, current, step)
	return current.x + step.x >= self.parent.rows
		or current.x + step.x <= -1
		or current.y + step.y >= self.parent.cols
		or current.y + step.y  <= -1
end

function LightBeam.inGrid(self, current)
	return current.x < self.parent.rows
		and current.x >= 0
		and current.y < self.parent.cols
		and current.y >= 0
end

function LightBeam.step(current, step)
		current.x = current.x + step.x
		current.y = current.y + step.y
end

function LightBeam.drawBeam(self, emit, collision, dir)
	-- global location variables
	local origin = {x = self.parent.x, y = self.parent.y}
	local cellDim = self.parent.width / self.parent.rows
	-- calculate centers of "lit" squares
	local finish = {x = origin.x + cellDim * (collision.x + .5), y = origin.y + cellDim * (collision.y + .5)}
	self.step(origin, {x = cellDim * (emit.x + .5), y = cellDim * (emit.y + .5)})
	-- draw
	love.graphics.line(origin.x, origin.y, finish.x, finish.y)
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