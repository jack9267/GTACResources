
local thisResource = Engine.GetThisResource()

function spawnPlayer(player,override)
	local Game = player:GetData("Game")
	if Game == Engine.Game.GTA.SA then
		player:Spawn(1829,-1843,13.578,33)
		--player:Spawn(-578.03619384766,-1109.2202148438,23.365419387817,33)--152)
	elseif Game == Engine.Game.GTA.VC then
		player:Spawn(-592, 670, 11.08, 0)
	elseif Game == Engine.Game.GTA.III then
		local skin = math.random(0,78)
		if skin >= 26 then
			skin = skin + 4
		end
		--player:Spawn(1155.198, 42.296, -0.52, skin)
		player:Spawn(-362.94, 239.359, 60.654, skin)
	end
	player:SetData("respawning",false)
end

Engine.EventSystem.GetEventType("OnResourceStart"):AddHandler(function(event,resource)
	if thisResource == resource then
		for i,v in ipairs(Engine.GetElementsByType(Engine.Elements.Player)) do
			spawnPlayer(v)
		end
	end
end)

Engine.EventSystem.GetEventType("OnPlayerJoined"):AddHandler(function(event,client)
	local player = client:GetPlayer()
	spawnPlayer(player,22)
end)

Engine.EventSystem.GetEventType("OnProcess"):AddHandler(function(event)
	for i,v in ipairs(Engine.GetElementsByType(Engine.Elements.Player)) do
		if v:GetHealth() <= 0.0 then
			if not v:GetData("respawning") then
				Engine.Shared.SetTimer(function() spawnPlayer(v) end,5.0,1)
				v:SetData("respawning",true)
			end
		end
	end
end)
