local GridSpace = {}
local Stack = require("stack_module")

--[[
Define a GridContainer to act as the primary layout manager.
]]--

local GridContainer = {

	putObject = function(self, obj, x, y)
	-- store obj at (x,y)
		obj.x = self.x + (self.width / self.rows) * x
		obj.y = self.y + (self.height / self.cols) * y
		
		self.obj[x][y]:push(obj)
	end,
	
	pickObject = function(self, x, y)
		local gridx = math.floor(self.rows*(x-self.x)/self.width)
		local gridy = math.floor(self.cols*(y-self.y)/self.height)

		if gridx < 0 or gridy < 0
		then 
			return nil
		end
		--love.graphics.print("lol",100aitembox:getFirstEmptySpace())aaaa

		return self.obj[gridx][gridy]:top()
	end,

	getObject = function(self, x, y)
		return self.obj[x][y]:top()
	end,

	removeObjectAt = function(self, x, y)
	-- remove obj from (x,y)
		local gridx = math.floor(self.rows*(x-self.x)/self.width)
		local gridy = math.floor(self.cols*(y-self.y)/self.height)

		self.obj[gridx][gridy]:pop()
	end,
		
	removeObject = function(self, x, y)
	-- remove any object from (x,y)
		self.obj[x][y]:pop()
	end,
	
	snapObject = function(self, obj)
		local near_x = obj.x / (self.width / self.rows)
		local near_y = obj.y / (self.height / self.cols)
		near_x = math.min(math.max(math.floor(near_x + .5),0),self.rows - 1)
		near_y = math.min(math.max(math.floor(near_y + .5),0),self.cols - 1)
		obj.x = self.x + (self.width / self.rows) * near_x
		obj.y = self.y + (self.width / self.rows) * near_y
		self:putObject(obj, near_x, near_y)
	end,

	snapObjectAt = function(self, obj, x, y)
		local near_x = (x - self.x) / (self.width / self.rows)
		local near_y = (y - self.y) / (self.height / self.cols)
		near_x = math.min(math.max(math.floor(near_x),0),self.rows - 1)
		near_y = math.min(math.max(math.floor(near_y),0),self.cols - 1)
		obj.x = self.x + (self.width / self.rows) * near_x
		obj.y = self.y + (self.width / self.rows) * near_y
		self:putObject(obj, near_x, near_y)
	end,
	
	getFirstEmptySpace = function(self)
		for i = 0, self.rows, 1 do
			for j = 0, self.cols, 1 do
				if self:getObject(j,i) == nil then
					return j,i
				end
			end
		end
		return nil
	end,

	draw = function(self)
		love.graphics.line(self.x, self.y, self.x+self.width, self.y)
		love.graphics.line(self.x, self.y, self.x, self.y+self.height)

		local cWidth = self.width / self.rows
		local cHeight = self.height / self.cols

		for lclX = cWidth, self.width, cWidth do
			love.graphics.line(self.x + lclX, self.y, self.x + lclX, self.y+self.height)
		end

		for lclY = cHeight, self.height, cHeight do
			love.graphics.line(self.x , self.y + lclY, self.x + self.width, self.y + lclY)
		end

		for x = 0, self.rows, 1 do
			for y = 0, self.cols, 1 do
				local obj = self.obj[x][y]:top()
				if(obj)
				then
					-- TODO: for each in objs
					local l, t = self.x + x * cWidth, self.y + y * cHeight
					local r, b = l + cWidth, t + cHeight

					obj:drawFill(l, t, r, b)

					local num_objs = self.obj[x][y]:size()

					-- TODO: nicer print, arbitrary padding of 5 for now
					if (num_objs > 1) then
						love.graphics.print(self.obj[x][y]:size(), l+5, t+5)
					end

				end
			end
		end
	-- maybe a border
	end,

	inGrid = function(self, y)
		return (y > self.y) and (y < self.height)
	end,
}

local GridContainer_mt = {__index = GridContainer}

-- Need the metatable to be defined before this point
GridContainer.ctor = function(self, l, t, w, h, r, c)
	local t = {x = l, y = t, width = w, height = h, rows = r, cols = c }
	t.obj = {}
	for lx = 0, r, 1 do
		t.obj[lx] = {}
		
		-- fill with stack
		for ly = 0, c, 1 do
			t.obj[lx][ly] = Stack()
		end
	end

	setmetatable(t, GridContainer_mt)
	return t
end

local GridContainer_cmt = {__call = GridContainer.ctor}

setmetatable(GridContainer, GridContainer_cmt)

GridSpace.GridContainer = GridContainer

--[[
Define a GridObject to act as a container for drawable content.
]]--

local GridObject = {}

function GridObject.draw(self)
	love.graphics.draw(self.image, self.x, self.y, 0, self.s)
end

function GridObject.drawOffset(self, dx, dy)
	love.graphics.draw(self.image, self.x+dx, self.y+dy, 0, self.s)
end

function GridObject.drawFill(self, l, t, r, b)
	local image = self.image
	local w = image:getWidth()
	local h = image:getHeight()
	local xScale = (r-l)/w
	local yScale = (b-t)/h
	local scale = math.min(xScale, yScale)
	local drawX = l + math.floor(( (r-l) - w * scale ) / 2)
	local drawY = t + math.floor(( (b-t) - h * scale ) / 2)
	love.graphics.draw(image, drawX, drawY, 0, scale)
	self.s = scale
	self.x = drawX
	self.y = drawY
	self.w = w * scale
	self.h = h * scale
end

local GridObject_mt = {__index = GridObject}

function GridObject.ctor(self, image, x, y)
	local t = {x = x or 0, y = y or 0}
	t.image = image
	setmetatable(t, GridObject_mt)
	return t
end

local GridObject_cmt = {__call = GridObject.ctor}

setmetatable(GridObject, GridObject_cmt)

GridSpace.GridObject = GridObject

return GridSpace
