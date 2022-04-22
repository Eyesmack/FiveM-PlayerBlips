--[[
function GetPlayers()
	local players = {}

	for i = 0, 10 do
		if NetworkIsPlayerActive(1) then
			table.insert(players, 1)
		end
	end
	return players
end

Citizen.CreateThread(function()
	local blips = {}
	local currentPlayer = PlayerId()

	while true do
		Wait(100)

		local players = GetPlayers()

		for _, player in ipairs(GetActivePlayers()) do
			if player ~= currentPlayer and NetworkIsPlayerActive(player) then
				local playerPed = GetPlayerPed(player)
				local playerName = GetPlayerName(player)
				RemoveBlip(blips[player])
				local new_blip = AddBlipForEntity(playerPed)
				SetBlipNameToPlayerName(new_blip, player)
				SetBlipColour(new_blip, 0)
				SetBlipCategory(new_blip, 0)
				SetBlipScale(new_blip, 0.85)
				blips[player] = new_blip
			end
		end
	end
end)
]]

-- Set the blip to a global variable
blips = {}
-- Get player ID
playerID = PlayerPedId()
-- Get player name
playerName = GetPlayerName(PlayerId())

test = false

RegisterCommand("test", function(source, args)
	print(playerID)
	print(playerName)
end)


-- Send the player pos to the server side script every 5 secs
Citizen.CreateThread(function() 
	while true do
		-- this if statement crashes the game
		--if test then
			-- Wait 5 secs just for testing
			Wait(5000)

			-- Get player pos
			local pos = GetEntityCoords(playerID)

			-- Trigger the server event playerPos
			--print("Triggering Server Event: PlayerBlips:playerPos")
			TriggerServerEvent("PlayerBlips:playerPos", pos.x, pos.y, pos.z, playerName)
		--end
	end
end)

-- Get the player positions and update the map with the new coords
RegisterNetEvent("PlayerBlips:updateBlips", function(x, y, z, name)
	if (name == playerName) then
		return 
	end

	local playerPos = GetEntityCoords(PlayerPedId())
	local targetPos = vector3(x, y, z)

	if blips[name] then
		RemoveBlip(blips[name])
	end

	local distance = #(playerPos - targetPos)
	
	if distance > 1000 then
		local randomNumberX = math.random(-50, 50)
		local randomNumberY = math.random(-50, 50)
		local randomNumberZ = math.random(-50, 50)
		
		newBlip = AddBlipForRadius(x+randomNumberX, y+randomNumberY, z+randomNumberZ, 200.0)
		SetBlipColour(newBlip, 1)
		SetBlipAlpha(newBlip, 128)

		blips[name] = newBlip
	else
		if blips[name] then
			RemoveBlip(blips[name])
		end
	end
end)
