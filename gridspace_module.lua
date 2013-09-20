local GridSpace = {}

GridSpace.GridContainer = {
	putObject = function(self, obj, x, y)
	-- store obj at (x,y)
		obj.x = self.x + (self.width / self.rows) * x
		obj.y = self.y + (self.height / self.cols) * y
		self.obj[x][y] = obj
	end,

	getObjects = function(self, x, y)
	-- return a collection of objects at (x,y)
		return self.obj[x][y]
	end,

	removeObject = function(self, obj, x, y)
	-- remove obj from (x,y)
		set = self.obj[x][y]
		print(set[obj])
	end,
	
	snapObject = function(self, obj)
		local near_x = obj.x / (self.width / self.rows)
		local near_y = obj.y / (self.height / self.cols)
		near_x = math.floor(near_x + .5)
		near_y = math.floor(near_y + .5)
		print (near_x)
		print (near_y)
		obj.x = self.x + (self.width / self.rows) * near_x
		obj.y = self.y + (self.width / self.rows) * near_y
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
				local objs = self.obj[x][y]
				if(objs)
				then
					objs:draw()
				end
			end
		end
	-- maybe a border
	end,
}

local GridContainer_mt = {__index = GridSpace.GridContainer}

GridSpace.GridContainer.ctor = function(self, l, t, w, h, r, c)
	local t = {x = l, y = t, width = w, height = h, rows = r, cols = c }
	t.obj = {}
	for lx = 0, r, 1 do
		t.obj[lx] = {}
	end
	setmetatable(t, GridContainer_mt)
	return t
end

local GridContainer_cmt = {__call = GridSpace.GridContainer.ctor}

setmetatable(GridSpace.GridContainer, GridContainer_cmt)

return GridSpace
