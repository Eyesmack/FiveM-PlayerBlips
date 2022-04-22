RegisterServerEvent("PlayerBlips:playerPos", function(x, y, z, name, blip)
    -- This will allow us to give the updated coords of the blip to everyone on the server
    -- The second argument of TRIGGER_CLIENT_EVENT (the -1), means that everyone on the server will take the new coords
    TriggerClientEvent("PlayerBlips:updateBlips", -1, x, y, z, name, blip)
end)