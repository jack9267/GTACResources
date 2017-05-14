
local thisResource = Engine.GetThisResource()
local localPlayer = Engine.GetLocalPlayer()

local speedometerTexture,speedometerNeedleTexture

function LoadPNG(path)
	local stream = Engine.OpenFile(path,false)
	local bufferedStream = Engine.CreateBufferedStream(stream)
	local image = Engine.Image.LoadPNG(bufferedStream)
	bufferedStream:Close()
	stream:Close()
	return image
end

Engine.EventSystem.GetEventType("OnResourceReady"):AddHandler(function(event,resource)
	if thisResource == resource then
		speedometerTexture = LoadPNG("Speedometer.png")
		speedometerNeedleTexture = LoadPNG("SpeedometerNeedle.png")
	end
end)

function GetAspectRatio()
	return 16.0/9.0
end

function getVehicleSpeedometerType(vehicle)
	local minRotation = -1.814
	local maxRotation = 1.814
	local minSpeed = 0
	local maxSpeed = 160
	local knots = false --GetVehicleSubtype(vehicle) == VEHICLESUBTYPE_BOAT
	local speedometerTexture2
	if knots then
		speedometerTexture2 = speedometerKnotsTexture
	else
		speedometerTexture2 = speedometerTexture
	end
	return minRotation, maxRotation, minSpeed, maxSpeed, speedometerTexture2, speedometerNeedleTexture, 0xFFFFFFFF, 0xFFFF0000
end

function getVehicleDisplaySpeedRotation(vehicle)
	local minRotation, maxRotation, minSpeed, maxSpeed, texture, needleTexture, colour, needleColour = getVehicleSpeedometerType(vehicle)
	local displaySpeedRotation = vehicle:GetData("displaySpeedRotation")
	if displaySpeedRotation == nil then displaySpeedRotation = minRotation end
	return displaySpeedRotation
end

function getDotProduct(x,y,z,x2,y2,z2)
	return x*x2 + y*y2 + z*z2
end

function getLength(x,y,z)
	return math.sqrt(getDotProduct(x,y,z,x,y,z));
end

function extract(n,l,h)
	return (((n)-(l))/((h)-(l)))
end

local function processSpeedometer(vehicle,timeStep)
	local minRotation, maxRotation, minSpeed, maxSpeed, texture, needleTexture, colour, needleColour = getVehicleSpeedometerType(vehicle)
	if minRotation == nil then return end
	local matrix = vehicle:GetMatrix():ToTable()
	local frontSpeed = true
	local displaySpeedRotation = getVehicleDisplaySpeedRotation(vehicle)
	local targetRotation
	local speedX, speedY, speedZ = vehicle:GetVelocity()
	local speed
	if frontSpeed then
		speed = getDotProduct(speedX,speedY,speedZ,matrix[2][1],matrix[2][2],matrix[2][3])
	else
		speed = getLength(speedX,speedY,speedZ)
	end
	speed = speed*90
	speed = math.abs(speed)
	targetRotation = minRotation+extract(speed,minSpeed,maxSpeed)*(maxRotation-minRotation)
	displaySpeedRotation = displaySpeedRotation+(targetRotation-displaySpeedRotation)/5*timeStep
	displaySpeedRotation = math.max(displaySpeedRotation,minRotation)
	displaySpeedRotation = math.min(displaySpeedRotation,maxRotation)
	vehicle:SetData("displaySpeedRotation",displaySpeedRotation)
end

Engine.EventSystem.GetEventType("OnProcess"):AddHandler(function(event)
	local vehicle = localPlayer:GetOccupiedVehicle()
	if vehicle == nil then return end
	local timeStep = Engine.GTA.GetTimeStep()
	processSpeedometer(vehicle,timeStep)
end)

Engine.EventSystem.GetEventType("OnDrawnHUD"):AddHandler(function(event)
	local vehicle = localPlayer:GetOccupiedVehicle()
	if vehicle == nil then return end
	local minRotation, maxRotation, minSpeed, maxSpeed, texture, needleTexture, colour, needleColour = getVehicleSpeedometerType(vehicle)
	if minRotation == nil then return end
	local widthMultiplier = Engine.GTA.Window.GetWidth()/Engine.GTA.Window.GetHeight()/GetAspectRatio()
	local rightGap = 27.0/1024.0*Engine.GTA.Window.GetWidth()
	local bottomGap = -25.0/768.0*Engine.GTA.Window.GetHeight()
	local size = 350.0/768.0*Engine.GTA.Window.GetHeight()
	local dropShadow = 1.5
	local sizeX = size
	local sizeY = size
	local scaleX = 1*widthMultiplier
	local scaleY = 1
	local posX = Engine.GTA.Window.GetWidth()-sizeX*scaleX/2-rightGap*scaleX
	local posY = Engine.GTA.Window.GetHeight()-sizeY*scaleY/2-bottomGap*scaleY
	local displaySpeedRotation = getVehicleDisplaySpeedRotation(vehicle)
	Engine.TwoDimensional.DrawRectangle(texture,posX,posY,sizeX,sizeY,0xFF000000,0xFF000000,0xFF000000,0xFF000000,0.0,0.5,0.5,0,0,1,1,scaleX,scaleY)
	Engine.TwoDimensional.DrawRectangle(needleTexture,posX,posY,sizeX,sizeY,0xFF000000,0xFF000000,0xFF000000,0xFF000000,displaySpeedRotation,0.5,0.5,0,0,1,1,scaleX,scaleY)
	Engine.TwoDimensional.DrawRectangle(texture,posX-dropShadow,posY-dropShadow,sizeX,sizeY,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0.0,0.5,0.5,0,0,1,1,scaleX,scaleY)
	Engine.TwoDimensional.DrawRectangle(needleTexture,posX-dropShadow,posY-dropShadow,sizeX,sizeY,needleColour,needleColour,needleColour,needleColour,displaySpeedRotation,0.5,0.5,0,0,1,1,scaleX,scaleY)
end)
