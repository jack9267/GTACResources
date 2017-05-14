
local thisResource = Engine.GetThisResource()
local games = {"Unknown","Grand Theft Auto III","Grand Theft Auto: Vice City","Grand Theft Auto: San Andreas"}

Engine.EventSystem.GetEventType("OnResourceStart"):AddHandler(function(event,resource)
	if thisResource == resource then
	end
end)

Engine.EventSystem.GetEventType("OnPlayerJoin"):AddHandler(function(event,client)
	local playerIndex = client:GetIndex()
	local skin = 0
	local player = Engine.Player(0)
	client:SetPlayer(player)

	-- so we know game/gameversion of the client
	player:SetData("Game",client:GetGame())
	player:SetData("GameVersion",client:GetGameVersion())

	player:SetSyncer(client)
	player:Add()
	player:SetResource(nil)

	print(client:GetName() .. " is joining [" .. games[client:GetGame()+1] .. "]")
end)
