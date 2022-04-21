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

-- Send the player pos to the server side script every 5 secs
Citizen.CreateThread(function() 
	while true do
		-- Wait 5 secs
		Wait(5000)

		-- Get player pos
		local playerPed = PlayerPedId() -- get the local player ped
		local pos = GetEntityCoords(playerPed) -- get the pos of the local player ped

		-- Trigger the server event playerPos
		TriggerServerEvent("PlayerBlips:playerPos", pos.x, pos.y, pos.z)
		print("Triggered Server Event: PlayerBlips:playerPos")
	end
end)

-- Get the player positions and update the map with the new coords
RegisterNetEvent("PlayerBlips:updateBlips", function(x, y, z)
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
end)