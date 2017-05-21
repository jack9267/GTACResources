
local thisResource = Engine.GetThisResource()
local wastedState = 0
local timer

function OnWasted()
	Engine.GTA.Messages.AddBigMessage("DEAD",4000,2)
	timer = 0.0
end

Engine.EventSystem.GetEventType("OnProcess"):AddHandler(function(event,deltaTime)
	local localPlayer = Engine.GetLocalPlayer()
	if localPlayer:GetHealth() <= 0.0 then
		if wastedState == 0 then
			OnWasted()
			wastedState = 1
		end
	end
	if wastedState == 1 then
		timer = timer + deltaTime
		if timer >= 3.0 then
			Engine.GTA.Camera.Fade(1.0,Engine.GTA.Fade.Out)
			wastedState = 2
		end
	end
end)

Engine.EventSystem.GetEventType("OnPedSpawn"):AddHandler(function(event,ped)
	if ped == Engine.GetLocalPlayer() then
		if wastedState == 2 then
			Engine.GTA.Camera.Fade(1.0,Engine.GTA.Fade.In)
		end
		wastedState = 0
	end
end)
