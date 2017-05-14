
local thisResource = Engine.GetThisResource()

Engine.EventSystem.GetEventType("OnResourceStart"):AddHandler(function(event,resource)
	if thisResource == resource then
		for i,v in ipairs(Engine.GetElementsByType(Engine.Elements.Player)) do
			local blip = Engine.Blip()
			blip:AttachTo(v)
			blip:Add()
		end
	end
end)

Engine.EventSystem.GetEventType("OnPlayerJoined"):AddHandler(function(event,client)
	local player = client:GetPlayer()

	local blip = Engine.Blip()
	blip:AttachTo(player)
	blip:Add()
end)

Engine.EventSystem.GetEventType("OnPlayerQuit"):AddHandler(function(event,client,reason)
	local player = client:GetPlayer()

	for i,v in ipairs(player:GetAttachedElements()) do
		if v:is_a(Engine.Blip) then
			v:Remove()
		end
	end
end)

Engine.EventSystem.GetEventType("OnElementStreamIn"):AddHandler(function(event,element,client)
	if element:is_a(Engine.Blip) then
		local attachee = element:GetAttachedTo()
		if attachee ~= nil and attachee == client:GetPlayer() then
			event:PreventDefault()
		end
	end
end)

