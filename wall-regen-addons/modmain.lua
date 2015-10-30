KnownModIndex = GLOBAL.KnownModIndex

-- workshop-357875628 = wall gates
-- workshop-509723993 = wall regen

-- Check if Wall Regen is enabled
if (KnownModIndex:IsModEnabled("workshop-509723993")) then
	local HEALTH_REGEN = GLOBAL.GetModConfigData("health_regen", "workshop-509723993")
	local REGEN_DELTA = GLOBAL.GetModConfigData("regen_value", "workshop-509723993")
	local WALL_UNDEPLOYABLE = GLOBAL.GetModConfigData("wall_undeployable", "workshop-509723993")
	
	if (KnownModIndex:IsModEnabled("workshop-358015908")) then
		if HEALTH_REGEN == 1 then
			local function regen( inst )
				inst:DoPeriodicTask(5, function( inst )
					local wall_health = inst.components.health:GetPercent()
					if wall_health < 1 then
						inst.components.health:DoDelta(REGEN_DELTA)
					end
				end)
			end
			AddPrefabPostInit("wall_tungsten", regen)
		end

		if WALL_UNDEPLOYABLE == 1 then
			--for wall_tungsten
			AddPrefabPostInit("wall_tungsten", function(inst)
				local function turnon(inst)
					inst.on = true
					inst:Remove()
					GLOBAL.SpawnPrefab("wall_tungsten_item").Transform:SetPosition(inst.Transform:GetWorldPosition())
				end
				inst:AddComponent("machine")
				inst.components.machine.turnonfn = turnon
			end)
		end
	end
	
	if (KnownModIndex:IsModEnabled("workshop-357875628")) then
		
		if HEALTH_REGEN == 1 then
			local function regen( inst )
				inst:DoPeriodicTask(5, function( inst )
					
					local anims = {
						{ threshold = 0, anim = "broken" },
						{ threshold = 0.4, anim = "onequarter" },
						{ threshold = 0.5, anim = "half" },
						{ threshold = 0.99, anim = "threequarter" },
						{ threshold = 1, anim = {"fullA", "fullB", "fullC"} },
					}
					
					local function resolveanimtoplay(inst, percent)
						for i,v in ipairs(anims) do
							if percent <= v.threshold then
								if type(v.anim) == "table" then
									local x,y,z = inst.Transform:GetWorldPosition()
									local x = math.floor(x)
									local z = math.floor(z)
									local t = ( ((x%4)*(x+3)%7) + ((z%4)*(z+3)%7) )% #v.anim + 1
									return v.anim[t]
								else
									return v.anim
								end
							end
						end
					end
					
					local function makeobstacle(inst)
						inst.Physics:SetActive(true)
						inst._ispathfinding:set(true)
					end
				
					local wall_health = inst.components.health:GetPercent()
					if wall_health < 1 then
						inst.components.health:DoDelta(REGEN_DELTA)
					end
					if (inst.components.wallgates.isopen == false) then
						local name = nil
						if inst.entity:HasTag("grass") then 
							name = "straw"
						elseif inst.entity:HasTag("wood") then 
							name = "wood"
						elseif inst.entity:HasTag("stone") then
							name = "stone"
						end
						
						local var = inst.components.health:GetPercent()
						if var <= 0 then
							inst.components.wallgates.isopen = true
							inst.AnimState:PushAnimation("broken")
						elseif var <= .4 then
							inst.components.wallgates.isopen = false
							inst.AnimState:PlayAnimation("onequarter")
							makeobstacle(inst)
						elseif var <= .5 then
							inst.components.wallgates.isopen = false
							inst.AnimState:PlayAnimation("half")
							makeobstacle(inst)
						elseif var <= .9 then
							inst.components.wallgates.isopen = false
							inst.AnimState:PlayAnimation("threequarter")
							makeobstacle(inst)
						else
							inst.AnimState:PlayAnimation(resolveanimtoplay(inst, inst.components.health:GetPercent()))
							inst.components.wallgates.isopen = false
							makeobstacle(inst)
						end
					end
				end)
			end
			AddPrefabPostInit("mech_hay", regen)
			AddPrefabPostInit("mech_stone", regen)
			AddPrefabPostInit("mech_wood", regen)
			AddPrefabPostInit("mech_ruins", regen)
			AddPrefabPostInit("mech_moonrock", regen)
			
			AddPrefabPostInit("locked_mech_moonrock", regen)
			AddPrefabPostInit("locked_mech_stone", regen)
			AddPrefabPostInit("locked_mech_ruins", regen)
		end
		
		if WALL_UNDEPLOYABLE == 1 then
			--for mech_hay
			AddPrefabPostInit("mech_hay", function(inst)
				local function turnon(inst)
					inst.on = true
					inst:Remove()
					GLOBAL.SpawnPrefab("mech_hay_item").Transform:SetPosition(inst.Transform:GetWorldPosition())
				end
				inst:AddComponent("machine")
				inst.components.machine.turnonfn = turnon
			end)
			--for mech_wood
			AddPrefabPostInit("mech_wood", function(inst)
				local function turnon(inst)
					inst.on = true
					inst:Remove()
					GLOBAL.SpawnPrefab("mech_wood_item").Transform:SetPosition(inst.Transform:GetWorldPosition())
				end
				inst:AddComponent("machine")
				inst.components.machine.turnonfn = turnon
			end)
			--for mech_stone
			AddPrefabPostInit("mech_stone", function(inst)
				local function turnon(inst)
					inst.on = true
					inst:Remove()
					GLOBAL.SpawnPrefab("mech_stone_item").Transform:SetPosition(inst.Transform:GetWorldPosition())
				end
				inst:AddComponent("machine")
				inst.components.machine.turnonfn = turnon
			end)
			-- for mech_ruins
			AddPrefabPostInit("mech_ruins", function(inst)
				local function turnon(inst)
					inst.on = true
					inst:Remove()
					GLOBAL.SpawnPrefab("mech_ruins_item").Transform:SetPosition(inst.Transform:GetWorldPosition())
				end
				inst:AddComponent("machine")
				inst.components.machine.turnonfn = turnon
			end)
			--for mech_moonrock
			AddPrefabPostInit("mech_moonrock", function(inst)
				local function turnon(inst)
					inst.on = true
					inst:Remove()
					GLOBAL.SpawnPrefab("mech_moonrock_item").Transform:SetPosition(inst.Transform:GetWorldPosition())
				end
				inst:AddComponent("machine")
				inst.components.machine.turnonfn = turnon
			end)
			
			--for locked_mech_moonrock
			AddPrefabPostInit("locked_mech_moonrock", function(inst)
				local function turnon(inst)
					inst.on = true
					inst:Remove()
					GLOBAL.SpawnPrefab("locked_mech_moonrock_item").Transform:SetPosition(inst.Transform:GetWorldPosition())
				end
				inst:AddComponent("machine")
				inst.components.machine.turnonfn = turnon
			end)
			--for locked_mech_stone
			AddPrefabPostInit("locked_mech_stone", function(inst)
				local function turnon(inst)
					inst.on = true
					inst:Remove()
					GLOBAL.SpawnPrefab("locked_mech_stone_item").Transform:SetPosition(inst.Transform:GetWorldPosition())
				end
				inst:AddComponent("machine")
				inst.components.machine.turnonfn = turnon
			end)
			--for locked_mech_ruins
			AddPrefabPostInit("locked_mech_ruins", function(inst)
				local function turnon(inst)
					inst.on = true
					inst:Remove()
					GLOBAL.SpawnPrefab("locked_mech_ruins_item").Transform:SetPosition(inst.Transform:GetWorldPosition())
				end
				inst:AddComponent("machine")
				inst.components.machine.turnonfn = turnon
			end)
		end
	end
end