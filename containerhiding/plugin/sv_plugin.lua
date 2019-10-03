--[[
	fuck you nigger fuck you!!!
--]]

local PLUGIN = PLUGIN;

function PLUGIN:ContainerHide(target, container, bState)
	if (!IsValid(container)) then
		return;
	else
		if (target:IsPlayer()) then
			container.playerContained = target;
		end;
	end;
	
	if (container:GetModel() == "models/props_c17/furnituredresser001a.mdl") then
		target.containerType = "wood";
	else
		target.containerType = "metal";
	end;
	
	if (IsValid(target) and target:IsPlayer()) then
		if (bState) then
			target:SetCharacterData("hidden", true);
			
			target:SetPos(container:LocalToWorld(Vector(5, 0, -45)))
			target:SetNoDraw(true);
			target:DrawShadow(false);
			target:GodEnable()
			target:SelectWeapon( "cw_hands" )

			container.occupied = true;
		else
			target:SetCharacterData("hidden", false);
			
			target:SetPos(container:LocalToWorld(Vector(45, 0, 0)))
			target:SetNoDraw(false);
			target:DrawShadow(true);
			target:GodDisable()
			target.containerType = nil;

			if (IsValid(container)) then
				container.playerContained = nil;
				
				container.occupied = false;
			end;
		end;
	end;
end;

-- Called when a player opens a storage entity.
function PLUGIN:OpenedStorage(player, entity)
	if (entity.playerContained) then
		local target = entity.playerContained;
		local startleSound = {
			"vo/npc/male01/ohno.wav",
			"vo/npc/male01/uhoh.wav",
			"vo/npc/male01/startle01.wav",
			"vo/npc/male01/startle02.wav",
			"vo/npc/female01/ohno.wav",
			"vo/npc/female01/uhoh.wav",
			"vo/npc/female01/startle01.wav",
			"vo/npc/female01/startle02.wav"
		};
		
		if (target.containerType) then
			if (target.containerType == "metal") then
				target:EmitSound("physics/metal/metal_box_break"..math.random(1, 2)..".wav", 60);
			elseif (target.containerType == "wood") then
				target:EmitSound("physics/wood/wood_crate_break"..math.random(1, 5)..".wav", 60);
			end;
		end;
		
		self:ContainerHide(entity.playerContained, entity, false);
		
		if (target:GetGender() == GENDER_MALE) then
			target:EmitSound(startleSound[math.random(1, 4)]);
		else
			target:EmitSound(startleSound[math.random(5, 8)]);
		end;

		Clockwork.player:SetRagdollState(target, RAGDOLL_FALLENOVER, 6);
	end;
end;

--[[
	add this to the bottom of Clockwork.storage:Open(player, data) in libraries/server/sv_storage.lua
	
	Clockwork.plugin:Call("OpenedStorage", player, data.entity);
--]]