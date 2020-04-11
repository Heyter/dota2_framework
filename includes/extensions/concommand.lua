if not concommand then
	concommand = {}
end

function concommand.Add(name, callback, helpText, flags)
	if (not isfunction(callback)) then return end
	
	Convars:RegisterCommand(name, function(...)
		local array = {...}
		local old_cmd = array[1]
		
		table.remove(array, 1)

		callback(Convars:GetCommandClient(), old_cmd, array)
		old_cmd, array = nil, nil
		
	end, helpText, flags or 0)
end