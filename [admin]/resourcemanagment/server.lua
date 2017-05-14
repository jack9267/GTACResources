
local thisResource = Engine.GetThisResource()

Engine.AddCommandHandler("update",function(commandName,arguments,client)
	Engine.UpdateResources()
end)

Engine.AddCommandHandler("start",function(commandName,arguments,client)
	if arguments then
		Engine.UpdateResources()
		local resource = Engine.FindResourceByName(arguments)
		if resource == nil then
			Engine.OutputChatBox("Unable to find the resource!",3,client)
		else
			resource:Start()
		end
	end
end)

Engine.AddCommandHandler("stop",function(commandName,arguments,client)
	if arguments then
		local resource = Engine.FindResourceByName(arguments)
		if resource == nil then
			Engine.OutputChatBox("Unable to find the resource!",3,client)
		else
			resource:Stop()
		end
	end
end)

Engine.AddCommandHandler("restart",function(commandName,arguments,client)
	if arguments then
		Engine.UpdateResources()
		local resource = Engine.FindResourceByName(arguments)
		if resource == nil then
			Engine.OutputChatBox("Unable to find the resource!",3,client)
		else
			resource:Restart()
		end
	end
end)
