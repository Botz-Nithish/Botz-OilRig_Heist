ESX = exports["es_extended"]:getSharedObject()
isplayerrob = false
local hide_search_zones = {}
local search_zones = {}
local pump_zones = {}
local pump_t,search_t,hide_search_t = false,false,false
playernotdied = true
local exit_zone
------------------------------------Creating Ped for Trigger----------------------------------------------------
auntyrob_spawn_Ped = function()
    lib.RequestModel(Config.oilrig_ped.model)
    oilrig_ped = CreatePed(0, Config.oilrig_ped.model, Config.oilrig_ped.location, Config.oilrig_ped.heading, false, true)
    FreezeEntityPosition(oilrig_ped, true)
    SetBlockingOfNonTemporaryEvents(oilrig_ped, true)
    SetEntityInvincible(oilrig_ped, true)
    TaskStartScenarioInPlace(oilrig_ped, Config.oilrig_ped.scenario, 0, true) 
end

local function onEnterped(self)
    auntyrob_spawn_Ped()
    exports.ox_target:addLocalEntity(oilrig_ped, {
        name = 'oilrig_trigger_ped',
        icon = self.target_icon,
        label = self.target_label,
        distance = 2,
        canInteract = function(entity, coords, distance)
            return IsPedOnFoot(cache.ped) and not IsPlayerDead(cache.ped)
        end,
        onSelect = function()
            local status = lib.callback.await('botz_oilrigrob:robberystatus', false)
            if status == 3 then
                notify({des = 'Not enough police in the city.', status ='error'})
            elseif status == 2 then
                local data = lib.callback.await('botz_oilrigrob:robberystart', false)
                print(data)
                    if data then
                        if lib.progressBar({
                            duration = 5000,
                            label = 'Thinking...',
                            useWhileDead = false,
                            canCancel = false,
                            disable = {
                                car = true,
                                mouse =false,
                                move = true,
                                combat = true,
                                sprint = true
                            },
                            anim = {
                                dict = 'random@shop_tattoo',
                                clip = '_idle_a'                                        
                            },
                        }) then
                            notify({des = 'Some people have terrorized my oil rig. Eliminate them, and whatever is there is yours!', status ='success'})
                            --botz_npc()
                            Searchinglocations()
                            isplayerrob = true
                            --Checkplayerdied()
                            oilrigrob_exitzone()
                        end
                    else
                        notify({des = 'Bribe me harder.', status ='error'})
                    end   
            elseif status == 1 then
                notify({des = 'I dont like your Offer, Please approach me with a better Offer', status ='error'})
            else
                notify({des = 'Alright I am on a Contract, Please approach me later once I am done with the existing Contract', status ='error'}) 
            end
        end
    })
end



local function onExitped(self)
    DeleteEntity(oilrig_ped)
    exports.ox_target:removeLocalEntity(oilrig_ped, nil)
end
 
local points = lib.points.new({
    coords = Config.oilrig_ped.location,
    heading = Config.oilrig_ped.heading,
    distance = Config.oilrig_ped.distance,
    model = Config.oilrig_ped.model,
    scenario = Config.oilrig_ped.scenario,
    target_label = Config.oilrig_ped.target_label,
	target_icon = Config.oilrig_ped.target_icon,
    onEnter = onEnterped,
    onExit = onExitped,
})
------------------------------------Creating Ped for Trigger----------------------------------------------------

------------------------------------ Spawning of Bots -----------------------------------------------------------
local function requestModels(model)
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do 
        Wait(500)
    end 
end 

function botz_npc()
    CreateThread(function()
    print("interlinkage")
    local model = Config.Mission.NPCModel
    requestModels(model)
    missionNPCTable = {}
for i = 1, #Config.Mission.NPCLocations, 1 do 
    missionNPCTable[i] = CreatePed(1, GetHashKey(Config.Mission.NPCModel), Config.Mission.NPCLocations[i], true, true)
    GiveWeaponToPed(missionNPCTable[i], GetHashKey('weapon_pistol'), 250, false, true)
    SetCurrentPedWeapon(missionNPCTable[i], GetHashKey('weapon_pistol'), true)
    SetPedCombatAbility(missionNPCTable[i], 100)
    SetPedRelationshipGroupHash(missionNPCTable[i], 'AGGRESSIVE_INVESTIGATE')
    Wait(500)
end 
end)
end
------------------------------------ Spawning of Bots -----------------------------------------------------------


-------------------------------------Creating Search Location after the Peds Died---------------------------------
Searchinglocations = function()
    
    local total_zones = 0
    
    CreateThread(function()
        for k,v in pairs(Config.SearchLocations) do
            search_zones[k] = exports.ox_target:addBoxZone({
                coords = v.coords,
                size = v.size,
                rotation = v.rotation,
                debug = Config.debug,
                drawSprite = Config.debug,
                options = {
                    {
                        icon = 'fas fa-gem',
                        label = 'ROB!',
                        distance = 1.5,
                        onSelect = function()
                            local success = true
                            --local success = exports['SN-Hacking']:MemoryCards('easy')
                            if success then
                                exports.ox_target:removeZone(search_zones[k])
                                if lib.progressCircle({
                                    duration = Config.SearchTimer,
                                    position = 'bottom',
                                    useWhileDead = false,
                                    canCancel = false,
                                    disable = {
                                        car = true,
                                        mouse =true,
                                        move = true,
                                        combat = true,
                                        sprint = true
                                    },
                                    anim = v.anim,
                                }) then 
                                    local data = lib.callback.await('botz_oilrigrob:give_porul', false,v.reward_items)
                                    if data then
                                        notify({des = 'Successfully Robbed', status ='success'})
                                        total_zones = total_zones - 1
                                    end
                                    if total_zones == 0 then
                                        local data = lib.callback.await('botz_oilrigrob:robfinish', false,Config.Finishreward)
                                        if data then
                                            exit_zone:remove()
                                            isplayerrob = false
                                            notify({des = 'Robbery Finished', status ='success'})
                                        end
                                        return
                                    end
                                end
                            else
                                notify({des = 'Hack Failed', status ='error'})
                            end
                        end
                    }
                }
            })
            total_zones = 1 + total_zones
        end
    end)
end
-------------------------------------Creating Search Location after the Peds Died---------------------------------


-------------------------------------Checking if the players died for every 2 secs---------------------------------

RegisterNetEvent("esx:onPlayerDeath", function()
    isDead = true
    if not isplayerrob then return end
    print('I die')
    Wait(4000)
    --exit_zone:remove()
    for k,v in pairs(search_zones) do
        exports.ox_target:removeZone(search_zones[k])
    end
    SetEntityCoords(cache.ped, Config.Dielocation)
end)
-------------------------------------Checking if the players died for every 2 secs---------------------------------

----------------------------------Check if the player is exitted the zone or not-----------------------------------

function oilrigrob_exitzone()
    
    
    function onExit(self)
            for k,v in pairs(search_zones) do
                exports.ox_target:removeZone(search_zones[k])
            end
            lib.callback.await('botz_oilrigrob:robCancel', false)
            notify({des = 'Robbery cancelled, Went away!', status ='error'})

    
        exit_zone:remove()
    end
    function onEnter(self)
        botz_npc()
    end
    CreateThread(function()
        exit_zone = lib.zones.poly({
            points = {
                vec(-785.8385, 7337.7368, 1),
                vec(-1044.5166, 7318.5566, 1),
                vec(-1046.8483, 7605.7744, 1),
                vec(-743.9020, 7564.3638, 1),
            },
            thickness = 150,
            debug = Config.debug,
            onExit = onExit,
            onEnter = onEnter
        })
    end)    
end
----------------------------------Check if the player is exitted the zone or not-----------------------------------