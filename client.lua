-- Set the blips to a global array
blips = {}
-- Get player ID
playerID = GetPlayerPed(-1)
-- Get player name
playerName = GetPlayerName(PlayerId())
-- set the blip type to default crim
crim = true
blipC = 1
blipA = 128
-- set the radius of the crim blip
rad = 200
-- set the interval between coord checks
i = 10


RegisterCommand("crim", function(source, args)
	crim = true
	blipC = 1
	blipA = 128
end)

RegisterCommand("cop", function(source, args)
	crim = false
	blipC = 3
	blipA = 255
end)

RegisterCommand("radius", function(source, args)
	local arg = args[1] or 200
	TriggerServerEvent("PlayerBlips:updateRadius", arg)
end)

RegisterNetEvent("PlayerBlips:updateRadius", function(arg)
	rad = arg
end)

RegisterCommand("interval", function(source, args)
	local arg = args[1] or 10
	TriggerServerEvent("PlayerBlips:updateInterval", arg)
end)

RegisterNetEvent("PlayerBlips:updateInterval", function(arg)
	i = arg
end)

-- Send the player pos to the server side script every 5 secs
Citizen.CreateThread(function() 
	while true do
		-- Wait 10 secs just for testing
		Wait(i*1000)

		-- Get player pos
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local head = GetEntityHeading(playerID)

		-- Trigger the server event playerPos
		--print("Triggering Server Event: PlayerBlips:playerPos")
		TriggerServerEvent("PlayerBlips:playerPos", pos.x, pos.y, pos.z, head, playerName, crim, blipC, blipA)
	end
end)

-- Get the player positions and update the map with the new coords
RegisterNetEvent("PlayerBlips:updateBlips", function(x, y, z, head, name, crims, blipc, blipa)
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

		if crims then
			-- create the blip and add the random numbers to the coords of the player with radius var = rad
			newBlip = AddBlipForRadius(x+randomNumberX, y+randomNumberY, z+randomNumberZ, tonumber(rad..".0"))
		else
			newBlip = AddBlipForCoord(x, y, z)
			SetBlipScale(newBlip, 0.9)
			SetBlipSprite(newBlip, 6)
			AddTextEntry("PLAYER", name)
			BeginTextCommandSetBlipName("PLAYER")
			EndTextCommandSetBlipName(newBlip)
		end

		-- set the rotation
		SetBlipRotation(newBlip, math.ceil(head))
		-- set the blips color
		SetBlipColour(newBlip, blipc)
		-- set the blips alpha
		SetBlipAlpha(newBlip, blipa)

		-- add the blip to the blips array
		blips[name] = newBlip
	else
		-- if the player is less than 1000 units away remove the blip
		if blips[name] then
			RemoveBlip(blips[name])
		end
	end
end)