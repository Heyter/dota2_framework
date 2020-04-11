if not player then
	player = {}
end

function player.GetAll()
	local players = {}
	
	for pID = 0, PlayerResource:GetPlayerCount() - 1 do
		if PlayerResource:IsValidPlayer(pID) then
			players[#players + 1] = pID
		end
	end
	
	return players
end

function player.GetHumans()
	local players = {}
	
	for pID = 0, PlayerResource:GetPlayerCount() - 1 do
		if PlayerResource:IsValidPlayer(pID) and not PlayerResource:IsFakeClient(pID) then
			players[#players + 1] = pID
		end
	end
	
	return players
end