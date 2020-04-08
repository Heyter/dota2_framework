function table.GetKeys(tab)
	local keys = {}
	local id = 1

	for k, v in pairs(tab) do
		keys[id] = k
		id = id + 1
	end

	return keys
end

--[[---------------------------------------------------------
	Name: IsEmpty( tab )
	Desc: Returns whether a table has iterable items in it, useful for non-sequential tables
-----------------------------------------------------------]]
function table.IsEmpty(tab)
	if not istable(tab) then return false end
	return next(tab) == nil
end