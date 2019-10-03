--[[
	fuck you nigger fuck you!!!
--]]

local PLUGIN = PLUGIN;

function PLUGIN:Move(player, moveData)
	if (player:GetCharacterData("hidden")) then
		moveData:SetVelocity(Vector(0, 0, 0));
		
		return true;
	end;
end;

-- Called when an entity's menu option should be handled.
function PLUGIN:EntityHandleMenuOption(player, entity, option, arguments)
	local class = entity:GetClass();
	local goodProps = {
		"models/props_c17/furnituredresser001a.mdl",
		"models/props_wasteland/controlroom_storagecloset001a.mdl",
		"models/props_wasteland/controlroom_storagecloset001b.mdl",
		string.lower( "models/props_junk/TrashDumpster01a.mdl" ) ,
		"models/props_wasteland/kitchen_fridge001a.mdl"
	};
	
	if (class == "prop_physics") then
		if (table.HasValue(goodProps, string.lower(entity:GetModel()))) then
			if (arguments == "cw_entityHide") then
				if (entity.occupied) then
					self:OpenedStorage(entity.playerContained, entity);
				end;
				
				local hideTime = Schema:GetDexterityTime(player) / 2;
			
				Clockwork.player:SetAction(player, "hide", hideTime, nil, function()				
					self:ContainerHide(player, entity, true);
					player.entityID = entity;
				end);
			elseif (arguments == "cw_entityUnHide") then
				local hideTime = Schema:GetDexterityTime(player) / 3;
			
				Clockwork.player:SetAction(player, "unhide", hideTime, nil, function()			
					self:ContainerHide(player, entity, false);
					player.entityID = nil;
				end);
			end;
		end;
	end;
end;

-- Called when an entity is removed.
function PLUGIN:EntityRemoved(entity)
	if (IsValid(entity) and entity:GetClass() == "prop_physics") then
		if (entity.occupied) then
			self:OpenedStorage(entity.playerContained, entity);
		end;
	end;
end;

-- Called when a player attempts to drop an item.
function PLUGIN:PlayerCanDropItem(player, itemTable, noMessage)
	if (player:GetCharacterData("hidden") == true) then
		if (!noMessage) then
			Clockwork.player:Notify(player, "You cannot drop items while you are hiding in a prop!");
		end;
		
		return false;
	end;
end;

-- Called when a player attempts to use an item.
function PLUGIN:PlayerCanUseItem(player, itemTable, noMessage)
	if (player:GetCharacterData("hidden") == true) then
		if (!noMessage) then
			Clockwork.player:Notify(player, "You cannot use items while you are hiding in a prop!");
		end;
		
		return false;
	end;
end;

-- Called when attempts to use a command.
function PLUGIN:PlayerCanUseCommand(player, commandTable, arguments)
	if (player:GetCharacterData("hidden") == true) then
		local blacklisted = {
			"OrderShipment",
			"CharFallover"
		};
		
		if (table.HasValue(blacklisted, commandTable.name)) then
			Clockwork.player:Notify(player, "You cannot use this command while you are hiding in a prop!");
			
			return false;
		end;
	end;
end;

-- Called when the player's character data should be saved.
function PLUGIN:PlayerSaveCharacterData(player, data)
	if (data["hidden"]) then
		data["hidden"] = false;
	end;
end;

-- Called when the a player's character data should be restored.
function PLUGIN:PlayerRestoreCharacterData(player, data)
	data["hidden"] = false;
end;

-- Called when the shared vars shoud be set.
function PLUGIN:PlayerSetSharedVars(player, curTime)
	player:SetSharedVar("hiddenProp", player:GetCharacterData("hidden"));
end;