local Stack = {
	push = function(self, value)
		-- find new top of stack
		local first = self.first + 1
		self.first = first
		
		-- set top to value
		self[first] = value
	end,

	pop = function(self)
		-- return nil if empty
		if (self.first == -1) then
			return nil
		end

		-- find top of stack
		local first = self.first
		local value = self[first]

		-- remove top
		self[first] = nil
		self.first = first - 1

		return value
	end,

	top = function(self)
		-- return top of stack
		return self[self.first]
	end,

	-- get object at index
	objAt = function(self, index)
		-- return nil if nil index is provided
		if (index == nil) then 
			return nil 
		end

		return self[index]
	end,

	-- get size of stack
	size = function(self)
		return self.first + 1
	end
}

local Stack_mt = {__index = Stack}

Stack.new = function(self)
	local t = { first = -1 }
	setmetatable(t, Stack_mt)
	return t
end

Stack_nmt = {__call = Stack.new}

setmetatable(Stack, Stack_nmt)

return Stack
