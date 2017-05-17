
local thisResource = Engine.GetThisResource()

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
end

Engine.EventSystem.GetEventType("OnResourceReady"):AddHandler(function(event,resource)
	if thisResource == resource then
		local xml = Engine.ParseXML("content.xml")
		if xml ~= nil then
			for i,node in ipairs(xml[1].Children) do
				if node.Name == "object" then
					CreateObject(node.Attributes.model,tonumber(node.Attributes.x),tonumber(node.Attributes.y),tonumber(node.Attributes.z),tonumber(node.Attributes.anglex),tonumber(node.Attributes.angley),tonumber(node.Attributes.anglez))
				end
			end
		end
	end
end)

