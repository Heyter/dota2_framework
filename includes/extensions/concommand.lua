if not concommand then
	concommand = {}
end

function concommand.Add(name, callback, helpText, flags)
	if (not isfunction(callback)) then return end
	
	Convars:RegisterCommand(name, function(cmd, ...)
		callback(Convars:GetCommandClient(), cmd, {...})
	end, helpText, flags or 0)
end