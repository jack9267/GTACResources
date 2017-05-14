
local thisResource = Engine.GetThisResource()

local reasons = {"TIMEOUT","FULL","UNSUPPORTED CLIENT","UNSUPPORTED ENGINE","WRONG PASSWORD","UNSUPPORTED EXECUTABLE","GRACEFUL","BANNED","FAILED","INVALID NAME"}

Engine.EventSystem.GetEventType("OnPlayerJoin"):AddHandler(function(event,client)
	print(client:GetName() .. " joined the game.")
end)

Engine.EventSystem.GetEventType("OnPlayerQuit"):AddHandler(function(event,client,reason)
	print(client:GetName() .. " left the game. [" .. reasons[reason+1] .. "]")
end)
