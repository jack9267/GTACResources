Connection = class(function(self,Connection)
	self.Connection = Connection
	self.Headers = {}
	self.StatusCode = 200
	self.SentData = false
end)

function Connection:SendData(data)
	if not self.SentData then
		if self.StatusCode ~= 200 then
			Engine.HTTP.SetStatusCode(self.Connection,self.StatusCode)
		end
		for k,v in pairs(self.Headers) do
			Engine.HTTP.SetHeader(self.Connection,k,v)
		end
		self.SentData = true
	end
	Engine.HTTP.Echo(self.Connection,data)
end

function Connection:SetHeader(name,value)
	if self.SentData then
		error("cannot set header after sending data",2)
	end
	self.Headers[name] = value
end

function Connection:SetStatusCode(code)
	if self.SentData then
		error("cannot set status code after sending data",2)
	end
	self.StatusCode = code
end

Engine.EventSystem.GetEventType("OnHTTPRequest"):AddHandler(function(Event,Connection2,Path,QueryString)
	local Connection3 = Connection(Connection2)
	if OnHTTPRequest(Connection3,Path,QueryString) then
		if not Connection3.SentData then
			Connection3:SendData("")
		end
		Event:PreventDefault()
	end
end)