local Stack = {}

function Stack.new()
	 return {first = 0}
end

function Stack.push(stack, value)
	if (stack == nil) then 
		return nil 
	end

	-- find new top of stack
	local first = stack.first + 1
	stack.first = first
	
	-- set top of stack to value
	stack[first] = value
end

function Stack.pop(stack)
	if (stack == nil) then 
		return nil 
	end

	-- find top of stack
	local first = stack.first
	local value = stack[first]

	-- remove top of stack
	stack[first] = nil
	stack.first = first - 1

	return value
end

function Stack.top(stack)
	if (stack == nil) then 
		return nil 
	end

	-- return top of stack
	return stack[stack.first]
end

-- get object at index
function Stack.objAt(stack, index)
	if (stack == nil or index == nil) then 
		return nil 
	end
	return stack[index]
end

-- get size of stack
function Stack.size(stack)
	if (stack == nil) then 
		return nil 
	end
	return stack.first
end

return Stack
