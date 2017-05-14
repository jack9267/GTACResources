
local thisResource = Engine.GetThisResource()

function outputChatBoxR(message)
	return Engine.OutputChatBox(message, 0xFFC8FAC8)
end

local function runString(commandstring)
	outputChatBoxR("Executing client-side command: "..commandstring)
	local notReturned
	--First we test with return
	local commandFunction,errorMsg = load("return "..commandstring)
	if errorMsg then
		--It failed.  Lets try without "return"
		notReturned = true
		commandFunction, errorMsg = load(commandstring)
	end
	if errorMsg then
		--It still failed.  Print the error message and stop the function
		outputChatBoxR("Error: "..errorMsg)
		return
	end
	--Finally, lets execute our function
	results = { pcall(commandFunction) }
	if not results[1] then
		--It failed.
		outputChatBoxR("Error: "..results[2])
		return
	end
	if not notReturned then
		local resultsString = ""
		local first = true
		for i = 2, #results do
			if first then
				first = false
			else
				resultsString = resultsString..", "
			end
			local resultType = type(results[i])
			--if isElement(results[i]) then
			--	resultType = "element:"..getElementType(results[i])
			--end
			resultsString = resultsString..tostring(results[i]).." ["..resultType.."]"
		end
		outputChatBoxR("Command results: "..resultsString)
	elseif not errorMsg then
		outputChatBoxR("Command executed!")
	end
end

function AddNetworkEventHandler(name,handler)
	local eventType = Engine.NetworkEvents.GetEventType(name)
	if eventType == nil then
		eventType = Engine.NetworkEvents.EventType(name)
		Engine.NetworkEvents.AddEventType(eventType)
	end
	eventType:AddHandler(handler)
end

AddNetworkEventHandler("doCrun",function(event,commandString)
	runString(commandString)
end)

Engine.AddCommandHandler("crun",function(commandName,arguments)
	runString(arguments or "")
end)
