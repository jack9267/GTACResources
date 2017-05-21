
local thisResource = Engine.GetThisResource()
local timers = {}

Engine.EventSystem.GetEventType("OnResourceStart"):AddHandler(function(event,resource)
	if thisResource == resource then
		timers = {}
	end
end)

Engine.EventSystem.GetEventType("OnProcess"):AddHandler(function(event,deltaTime)
	for i,v in ipairs(timers) do
		v.time = v.time - deltaTime

		if v.time <= 0.0 then
			v.callback()
			if v.count > 0 then
				v.count = v.count - 1
			end
			v.time = v.interval
			if v.count == 0 then
				table.remove(timers,i)
			end
		end
	end
end)

function SetTimer(callback,interval,count)
	local timer = {}
	timer.callback = callback
	timer.interval = interval
	timer.count = count
	timer.time = interval

	table.insert(timers,timer)
end

Engine.Shared.SetTimer = SetTimer
