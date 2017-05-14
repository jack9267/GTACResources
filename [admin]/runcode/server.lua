
local thisResource = Engine.GetThisResource()

function isClientPrivileged(client)
	if client:GetName() == "Jack" then return true end
	return false
end

function outputChatBoxR(message)
	return Engine.OutputChatBox(message, 0xFFC8FAC8)
end

local function runString(commandstring)
	outputChatBoxR("Executing server-side command: "..commandstring)
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

Engine.AddCommandHandler("run",function(commandName,arguments,client)
	if isClientPrivileged(client) then
		runString(arguments or "")
	else
		Engine.OutputChatBox("You are unprivileged!",3,client)
	end
end)

Engine.AddCommandHandler("cdo",function(commandName,arguments,client)
	if isClientPrivileged(client) then
		Engine.TriggerNetworkEvent("doCrun",nil,arguments or "")
	else
		Engine.OutputChatBox("You are unprivileged!",3,client)
	end
end)
