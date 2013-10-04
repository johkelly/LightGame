local Stack = {}

function Stack.Create()
	local t = {}
	t._et = {}

	function t.push(...)
		if ...
		then
			local targs = {...}
			for _,v in pairs(targs) do
				table.insert(t._et, v)
			end
		end
	end 

	return t

end

return Stack
	
