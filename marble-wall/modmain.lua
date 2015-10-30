KnownModIndex = GLOBAL.KnownModIndex

local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local STRINGS = GLOBAL.STRINGS
local TECH = GLOBAL.TECH

PrefabFiles = 
{
	"thewall.lua"
}
Assets =
{
    Asset("ANIM", "anim/wall_pomarble.zip"), --This is the animation for your item while it is on the ground
    Asset("ATLAS", "images/inventoryimages/wall_pomarble_item.xml"),
    Asset("IMAGE", "images/inventoryimages/wall_pomarble_item.tex")
}

STRINGS.NAMES.WALL_POMARBLE_ITEM = "Polished Marble Wall."
STRINGS.NAMES.WALL_POMARBLE = "Polished Marble Wall"
STRINGS.RECIPE_DESC.WALL_POMARBLE_ITEM = "A strong and polished Marble Wall."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WALL_POMARBLE = "Nice polished marble wall!"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WALL_POMARBLE_ITEM = "Nice polished marble wall!"

AddRecipe("wall_pomarble_item", {Ingredient("marble", 6)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 6, nil, "images/inventoryimages/wall_pomarble_item.xml", "wall_pomarble_item.tex")

-- workshop-509723993 = Wall Health Regen
-- Check if Wall Regen is enabled
if (KnownModIndex:IsModEnabled("workshop-509723993")) then
	local HEALTH_REGEN = GLOBAL.GetModConfigData("health_regen", "workshop-509723993")
	local REGEN_DELTA = GLOBAL.GetModConfigData("regen_value", "workshop-509723993")
	local WALL_UNDEPLOYABLE = GLOBAL.GetModConfigData("wall_undeployable", "workshop-509723993")
	
	if HEALTH_REGEN == 1 then
		local function regen( inst )
			inst:DoPeriodicTask(5, function( inst )
				local wall_health = inst.components.health:GetPercent()
				if wall_health < 1 then
					inst.components.health:DoDelta(REGEN_DELTA)
				end
			end)
		end
		AddPrefabPostInit("wall_pomarble", regen)
	end

	if WALL_UNDEPLOYABLE == 1 then
		--for wall_pomarble
		AddPrefabPostInit("wall_pomarble", function(inst)
			local function turnon(inst)
				inst.on = true
				inst:Remove()
				GLOBAL.SpawnPrefab("wall_pomarble_item").Transform:SetPosition(inst.Transform:GetWorldPosition())
			end
			inst:AddComponent("machine")
			inst.components.machine.turnonfn = turnon
		end)
	end
end