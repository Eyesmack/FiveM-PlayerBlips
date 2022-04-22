-- Set the blips to a global array
blips = {}
-- Get player ID
playerID = PlayerPedId()
-- Get player name
playerName = GetPlayerName(PlayerId())

-- Send the player pos to the server side script every 5 secs
Citizen.CreateThread(function() 
	while true do
		-- Wait 5 secs just for testing
		Wait(5000)

		-- Get player pos
		local pos = GetEntityCoords(playerID)

		-- Trigger the server event playerPos
		--print("Triggering Server Event: PlayerBlips:playerPos")
		TriggerServerEvent("PlayerBlips:playerPos", pos.x, pos.y, pos.z, playerName)
	end
end)

-- Get the player positions and update the map with the new coords
RegisterNetEvent("PlayerBlips:updateBlips", function(x, y, z, name)
	-- if the name of the incoming coords is the same as our local player ignore the coords
	if (name == playerName) then
		return 
	end

	-- get the local player position
	local playerPos = GetEntityCoords(PlayerPedId())
	-- get the targets player position
	local targetPos = vector3(x, y, z)

	-- if the blip exists in the blips array, remove it
	if blips[name] then
		RemoveBlip(blips[name])
	end

	-- calculate the distance between the two players
	local distance = #(playerPos - targetPos)
	
	-- if the distance is more than 1000 units continue
	if distance > 1000 then
		-- calculate three random numbers between -150 and 150
		local randomNumberX = math.random(-150, 150)
		local randomNumberY = math.random(-150, 150)
		local randomNumberZ = math.random(-150, 150)
		
		-- create the blip and add the random numbers to the coords of the player with radius 200(must have .0 on the end)
		newBlip = AddBlipForRadius(x+randomNumberX, y+randomNumberY, z+randomNumberZ, 200.0)
		-- set the blips color
		SetBlipColour(newBlip, 1)
		-- set the blips alpha
		SetBlipAlpha(newBlip, 128)

		-- add the blip to the blips array
		blips[name] = newBlip
	else
		-- if the player is less than 1000 units away remove the blip
		if blips[name] then
			RemoveBlip(blips[name])
		end
	end
end)
