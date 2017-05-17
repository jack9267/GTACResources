
local thisResource = Engine.GetThisResource()
local bridgeObject1 = nil
local bridgeObject2 = nil
local bridgeBlown = false
local fireTimer = 0.0

function SetRotation(entity,rx,ry,rz)
	local x,y,z = entity:GetPosition()
	local matRotX = Engine.Matrix4x4()
	matRotX:SetRotateX(rx)
	local matRotY = Engine.Matrix4x4()
	matRotY:SetRotateY(ry)
	local matRotZ = Engine.Matrix4x4()
	matRotZ:SetRotateZ(rz)
	local mat = Engine.Matrix4x4()
	mat:SetMultiply(matRotX,matRotY)
	mat:SetMultiply(mat,matRotZ)
	entity:SetMatrix(mat)
	entity:SetPosition(x,y,z)
end

function CreateObject(modelIndex,x,y,z,anglex,angley,anglez)
	local object = Engine.Object(modelIndex)
	object:SetPosition(x,y,z)
	SetRotation(object,anglex/180.0*3.14,angley/180.0*3.14,anglez/180.0*3.14)
	object:Add()
	return object
end

function SetCallahanBridgeBlown(blown)
	local BRIDGEFUKB = 724
	local BRIDGEFUKA = 725

	bridgeBlown = blown
	fireTimer = 1.0

	if blown then
		if bridgeObject1 == nil then
			bridgeObject1 = CreateObject(BRIDGEFUKA,715.6875,-937.875,40.1875,0.0,0.0,0.0)
		end

		if bridgeObject2 == nil then
			bridgeObject2 = CreateObject(BRIDGEFUKB,787.8125,-939.1875,38.9375,0.0,0.0,0.0)
		end
	else
		if bridgeObject1 ~= nil then
			bridgeObject1:Remove()
			bridgeObject1 = nil
		end

		if bridgeObject2 ~= nil then
			bridgeObject2:Remove()
			bridgeObject2 = nil
		end
	end

	local NBBRIDGFK2 = 1140
	local NBBRIDGCABLS01 = 1141
	local NBBRIDGERDB = 1143
	local NBBRIDGERDA = 1145
	local DAMGBBRIDGERDA = 1146
	local DAMGBRIDGERDB = 1147
	local LODRIDGCABLS01 = 1181
	local LODRIDGERDB = 1183
	local LODRIDGERDA = 1184
	local LODGBRIDGERDB = 1185
	local LODGBBRIDGERDA = 1186
	local LODRIDGFK2 = 1187

	local function ReplaceBridgeModel(x,y,z,radius,model,model2)
		if blown then
			Engine.GTA.SwapNearestBuildingModel(x,y,z,radius,model,model2)
		else
			Engine.GTA.SwapNearestBuildingModel(x,y,z,radius,model2,model)
		end
	end

	ReplaceBridgeModel(525.3125,-927.0625,71.8125,20.0,NBBRIDGCABLS01,NBBRIDGFK2);
	ReplaceBridgeModel(706.375,-935.8125,67.0625,20.0,NBBRIDGCABLS01,NBBRIDGFK2);
	ReplaceBridgeModel(529.0,-920.0625,43.5,20.0,NBBRIDGERDB,DAMGBRIDGERDB);
	ReplaceBridgeModel(702.75,-939.9375,38.6875,20.0,NBBRIDGERDB,DAMGBRIDGERDB);
	ReplaceBridgeModel(529.0,-942.9375,43.5,20.0,NBBRIDGERDA,DAMGBBRIDGERDA);
	ReplaceBridgeModel(702.75,-919.9375,38.6875,20.0,NBBRIDGERDA,DAMGBBRIDGERDA);
	ReplaceBridgeModel(525.3125,-927.0625,71.8125,20.0,LODRIDGCABLS01,LODRIDGFK2);
	ReplaceBridgeModel(706.375,-935.8125,67.0625,20.0,LODRIDGCABLS01,LODRIDGFK2);
	ReplaceBridgeModel(521.125,-922.9375,43.5,20.0,LODRIDGERDB,LODGBRIDGERDB);
	ReplaceBridgeModel(702.75,-939.9375,38.6875,20.0,LODRIDGERDB,LODGBRIDGERDB);
	ReplaceBridgeModel(529.0,-940.0625,43.5,20.0,LODRIDGERDA,LODGBBRIDGERDA);
	ReplaceBridgeModel(702.75,-919.9375,38.6875,20.0,LODRIDGERDA,LODGBBRIDGERDA);
end

Engine.Shared.SetCallahanBridgeBlown = SetCallahanBridgeBown

Engine.EventSystem.GetEventType("OnProcess"):AddHandler(function(event,deltaTime)
	if bridgeBlown then
		fireTimer = fireTimer+deltaTime

		if fireTimer >= 1.0 then
			Engine.GTA.AddMovingParticleEffect(10,791.625,-936.875,38.3125,0,0,0,1,0,1000)
			Engine.GTA.AddMovingParticleEffect(10,788.3125,-938.4375,38.0625,0,0,0,1,0,1000)
			Engine.GTA.AddMovingParticleEffect(10,786.4375,-942.375,39.75,0,0,0,1,0,1000)

			fireTimer = 0.0
		end
	end
end)

Engine.AddCommandHandler("bridge",function(commandName,arguments)
	SetCallahanBridgeBlown(arguments ~= nil)
end)
