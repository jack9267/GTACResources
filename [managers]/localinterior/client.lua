
local thisResource = Engine.GetThisResource()

-- ensure the camera interior is set to the local player's interior

Engine.EventSystem.GetEventType("OnResourceReady"):AddHandler(function(event,resource)
	if thisResource == resource then
		local localPlayer = Engine.GetLocalPlayer()
		Engine.GTA.Camera.SetInterior(localPlayer:GetInterior())
	end
end)

Engine.EventSystem.GetEventType("OnPedSpawn"):AddHandler(function(event,ped)
	local localPlayer = Engine.GetLocalPlayer()
	if ped == localPlayer then
		Engine.GTA.Camera.SetInterior(localPlayer:GetInterior())
	end
end)
