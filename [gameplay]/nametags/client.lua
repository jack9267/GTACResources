
local thisResource = Engine.GetThisResource()
local localPlayer = Engine.GetLocalPlayer()
local font

local function CreateColour(Alpha,Red,Green,Blue)
	return Alpha << 24 | Red << 16 | Green << 8 | Blue
end

local function distance(x1,y1,z1,x2,y2,z2)
	local dx = x1 - x2
	local dy = y1 - y2
	local dz = z1 - z2
	return math.sqrt ( dx * dx + dy * dy + dz * dz )
end

Engine.EventSystem.GetEventType("OnResourceReady"):AddHandler(function(event,resource)
	if thisResource == resource then
		local stream = Engine.OpenFile("/Fonts/Ubuntu-L.ttf",false)
		font = Engine.Font(stream,12.0)
		stream:Close()
		stream = nil
	end
end)

local function renderNametag(x,y,health,text,alpha)
	alpha = 0.5*alpha
	health = math.max(0.0,math.min(1.0,health))
	if health > 0.0 then
		local hx,hy = x-100/2,y-25/2
		local colourB = CreateColour(math.floor(255.0*alpha),0,0,0)
		Engine.TwoDimensional.DrawRectangle(nil,hx,hy,100,25,colourB,colourB,colourB,colourB,0.0,0.0,0.0,0,0,1,1,1,1)
		local colour = CreateColour(math.floor(255.0*alpha),math.floor(255.0-(health*255.0)),math.floor(health*255.0),0)
		Engine.TwoDimensional.DrawRectangle(nil,hx+5,hy+5,(100-10)*health,25-10,colour,colour,colour,colour,0.0,0.0,0.0,0,0,1,1,1,1)
		y = y-30
	end
	if text == nil then return end
	if font == nil then return end
	local width,height = font:Measure(text,x,y,Engine.GTA.Window.GetWidth(),0,0.0,font:GetSize(),false)
	local colourT = CreateColour(math.floor(255.0*alpha),255,255,255)
	font:Render(text,x-width/2,y-height/2,Engine.GTA.Window.GetWidth(),0,0.0,font:GetSize(),colourT,false)
end

function renderNametagElement(element)
	local lx,ly,lz = localPlayer:GetPosition()
	local px,py,pz = element:GetPosition()
	pz = pz+0.9
	local x,y,z,w = Engine.GTA.Camera.GetScreenFromWorldPosition(px,py,pz)
	if z >= 0.0 then
		local name = element:GetData("Name")
		local health = 1.0
		if element:is_a(Engine.Ped) then
			health = element:GetHealth()/100.0
			--if not name then
			--	name = "Ped " .. element:GetId()
			--end
		elseif element:is_a(Engine.Vehicle) then
			health = element:GetHealth()/1000.0
			--if not name then
			--	name = "Vehicle " .. element:GetId()
			--end
		end
		--if not name then
		--	name = "Element " .. element:GetId()
		--end
		local dist = distance(lx,ly,lz,px,py,pz)
		if dist < 30.0 then
			renderNametag(x,y,health,name,1.0-dist/30.0)
		end
	end
end

Engine.EventSystem.GetEventType("OnDrawnHUD"):AddHandler(function(event)
	--renderNametagElement(localPlayer)
	for _,v in ipairs(Engine.GetElementsByType(Engine.Elements.Ped)) do
		renderNametagElement(v)
	end
	for _,v in ipairs(Engine.GetElementsByType(Engine.Elements.Vehicle)) do
		renderNametagElement(v)
	end
end)
