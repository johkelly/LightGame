local GridSpace = {}

GridSpace.GridContainer = {
	putObject = function(self, obj, x, y)
	-- store obj at (x,y)
		self.obj[x][y] = obj
		obj.x = self.x + (self.width / self.rows) * x
		obj.y = self.y + (self.height / self.cols) * y
	end,

	getObjects = function(self, x, y)
	-- return a collection of objects at (x,y)
	end,

	removeObject = function(self, obj, x, y)
	-- remove obj from (x,y)
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