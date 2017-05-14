
local thisResource = Engine.GetThisResource()

Engine.EventSystem.GetEventType("OnResourceReady"):AddHandler(function(event,resource)
	if thisResource == resource then
		Engine.GTA.Camera.Fade(0.5,Engine.GTA.Fade.In)
	end
end)
