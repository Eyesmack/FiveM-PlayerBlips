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
playerName = GetPlayerName(playerID)

-- Send the player pos to the server side script every 5 secs
Citizen.CreateThread(function() 
	while true do
		-- Wait .5 secs just for testing
		Wait(500)

		-- Get player pos
		local pos = GetEntityCoords(playerID)

		-- Trigger the server event playerPos
		print("Triggering Server Event: PlayerBlips:playerPos")
		TriggerServerEvent("PlayerBlips:playerPos", pos.x, pos.y, pos.z, playerName, playerID)
	end
end)

-- Get the player positions and update the map with the new coords
RegisterNetEvent("PlayerBlips:updateBlips", function(x, y, z, name, id)
	RemoveBlip(blip[name])

	local playerPos = GetEntityCoords(PlayerPedId())
	local targetPos = vector3(-1147.27, 1000.00, 203.92)

	local distance = #(playerPos - targetPos)

	print(distance)

	if distance > 30 then
		if name == playerName then return end
		blip = AddBlipForCoord(x, y, z)
		SetBlipScale(blip, 0.9)
		SetBlipSprite(blip, 364)
		SetBlipColour(blip, 0)
		SetBlipAlpha(blip, 255)
		
		-- test this
		AddTextEntry("PLAYER", "Player Name")
		BeginTextCommandSetBlipName("PLAYER")
		SetBlipCategory(blip, 2)
		EndTextCommandSetBlipName(blip)
		--[[ then try this
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Player Name")
		EndTextCommandSetBlipName(blip)
		]]

		print("Blip ID: " .. blip)
	end
end)