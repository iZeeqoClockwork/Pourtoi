--[[
	fuck you nigger fuck you!!!
--]]

local PLUGIN = PLUGIN;

-- Called when an entity's menu options are needed.
function PLUGIN:GetEntityMenuOptions(entity, options)
	local goodProps = {
		"models/props_c17/furnituredresser001a.mdl",
		"models/props_wasteland/controlroom_storagecloset001a.mdl",
		"models/props_wasteland/controlroom_storagecloset001b.mdl",
		string.lower( "models/props_junk/TrashDumpster01a.mdl" ) ,
		"models/props_wasteland/kitchen_fridge001a.mdl"
	};
	
	if (entity:GetClass() == "prop_physics") then
		if (table.HasValue(goodProps, string.lower(entity:GetModel()))) then
			if (Clockwork.Client:GetSharedVar("hiddenProp") == true) then
				options["Partir"] = "cw_entityUnHide";
			else
				options["Se cacher"] = "cw_entityHide";
			end;
		end;
	end;
end;

-- Called when the post progress bar info is needed.
function PLUGIN:GetPostProgressBarInfo()
	if (Clockwork.Client:Alive()) then
		local action, percentage = Clockwork.player:GetAction(Clockwork.Client, true);

		if (action == "hide") then
			return {text = "Vous etes caché dans un props.", percentage = percentage, flash = percentage > 75};
		end;
		
		if (action == "unhide") then
			return {text = "Vous partez de ce props.", percentage = percentage, flash = percentage > 75};
		end;
	end;
end;