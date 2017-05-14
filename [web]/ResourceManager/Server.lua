
local ThisResource = Engine.GetThisResource()

Engine.EventSystem.GetEventType("OnResourceStart"):AddHandler(function(Event,Resource)
	if ThisResource == Resource then
		--TODO: This
	end
end)

function OnHTTPRequest(Connection,Path,QueryString)
	local result, error2 = pcall(function ()
		Connection:SetHeader("Server",ThisResource:GetName())
		if Path == "" then
			Connection:SetHeader("Location","/"..ThisResource:GetName().."/")
			Connection:SetStatusCode(302)
			return true
		end
		if Path == "/start" then
			Engine.UpdateResources()
			local Resource = Engine.FindResourceByName(Engine.HTTP.QueryDecode(QueryString))
			Resource:Start()
			Connection:SetHeader("Location","/"..ThisResource:GetName().."/")
			Connection:SetStatusCode(302)
			return true
		end
		if Path == "/stop" then
			local Resource = Engine.FindResourceByName(Engine.HTTP.QueryDecode(QueryString))
			Resource:Stop()
			Connection:SetHeader("Location","/"..ThisResource:GetName().."/")
			Connection:SetStatusCode(302)
			return true
		end
		if Path == "/restart" then
			Engine.UpdateResources()
			local Resource = Engine.FindResourceByName(Engine.HTTP.QueryDecode(QueryString))
			if Resource:IsStarted() then
				Resource:Restart()
			else
				Resource:Start()
			end
			Connection:SetHeader("Location","/"..ThisResource:GetName().."/")
			Connection:SetStatusCode(302)
			return true
		end
		if Path == "/update" then
			Engine.UpdateResources()
			Connection:SetHeader("Location","/"..ThisResource:GetName().."/")
			Connection:SetStatusCode(302)
			return true
		end
		if Path == "/updateAndRestartAll" then
			Engine.UpdateResources()
			for k,Resource in ipairs(Engine.GetResources()) do
				if Resource:IsStarted() then
					Resource:Restart()
				end
			end
			Connection:SetHeader("Location","/"..ThisResource:GetName().."/")
			Connection:SetStatusCode(302)
			return true
		end
		if Path == "/" then
			Connection:SetHeader("Content-Type","text/html; charset=UTF-8")
			Connection:SendData("<!DOCTYPE html>\n")
			Connection:SendData("<html xmlns=\"http://www.w3.org/1999/xhtml\" lang=\"en\">\n")
			Connection:SendData("<head>\n")
			Connection:SendData("<title>Resource Manager</title>\n")
			Connection:SendData("<meta http-equiv=\"content-type\" content=\"text/html;charset=utf-8\"/>\n")
			Connection:SendData("<meta name=\"author\" content=\"Lucas Cardellini\"/>\n")
			Connection:SendData("</head>\n")
			Connection:SendData("<body>\n")
			for k,Resource in ipairs(Engine.GetResources()) do
				Connection:SendData("<a href=\"/"..Engine.HTTP.QueryEncode(Resource:GetName()).."/\">"..Engine.HTTP.HTMLSpecialChars(Resource:GetName()).."</a>")
				if Resource:IsStarted() then
					Connection:SendData(" (Started)")
					if Resource ~= ThisResource then
						Connection:SendData(" <a href=\"stop?"..Engine.HTTP.QueryEncode(Resource:GetName()).."\">Stop</a>")
					end
					Connection:SendData(" <a href=\"restart?"..Engine.HTTP.QueryEncode(Resource:GetName()).."\">Restart</a>")
				else
					Connection:SendData(" (Stopped)")
					Connection:SendData(" <a href=\"start?"..Engine.HTTP.QueryEncode(Resource:GetName()).."\">Start</a>")
				end
				Connection:SendData("<br/>\n")
			end
			Connection:SendData("<a href=\"update\">Update</a> <a href=\"updateAndRestartAll\">Update and Restart All</a>\n")
			Connection:SendData("</body>\n")
			Connection:SendData("</html>\n")
			return true
		end
	end)
	if result then
		if error2 then
			return true
		end
	else
		print(error2)
		Connection:SendData("<div>"..error2.."</div>")
		return true
	end
	return false
end