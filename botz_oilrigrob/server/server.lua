ESX = exports["es_extended"]:getSharedObject()

local lastrob = 0


lib.callback.register('botz_oilrigrob:robberystatus', function(source,index)
	local source = source
    if #ESX.GetExtendedPlayers('job', 'police') < Config.RequiredCopsCount then
        return 3
    elseif exports.ox_inventory:GetItem(source, Config.robberystart_item, nil, true) < 1 then 
        return 1
    elseif (os.time() - lastrob) < Config.cooldown_time* 60 and lastrob ~= 0 then
        return 0
    else
        return 2
    end
end)

lib.callback.register('botz_oilrigrob:robberystart', function(source)
	local source = source

    if (os.time() - lastrob) < Config.cooldown_time and lastrob ~= 0 and not exports.ox_inventory:GetItem(source, Config.robberystart_item, nil, true) >= 1 then 
        return false
    else
        exports.ox_inventory:RemoveItem(source, Config.robberystart_item, 1)
        lastrob = os.time()
        SendToDiscord(source,'robberyProcess')
        return true
    end
end)

lib.callback.register('botz_oilrigrob:give_porul', function(source, item)
	local source = source
    for _,i in pairs(item) do
        exports.ox_inventory:AddItem(source, i.item, i.count)
    end
    return true
end)



lib.callback.register('botz_oilrigrob:robfinish', function(source,item)
	local source = source
    for _,i in pairs(item) do
        exports.ox_inventory:AddItem(source, i.item, i.count)
    end
    SendToDiscord(source,'robberyFinished')
    return true
end)

lib.callback.register('botz_oilrigrob:robCancel', function(source)
	local source = source
    SendToDiscord(source,'robberyCanceled')
    return true
end)


SendToDiscord = function(sourceid,TYPE)  -- robberyProcess  robberyFinished

	local source = ESX.GetPlayerFromId(sourceid)
    local source_discord = GetPlayerIdentifierByType(sourceid, 'discord')
	local source_discord_id = source_discord:gsub("discord:", "")
	local source_license = GetPlayerIdentifierByType(sourceid, 'license')
	local source_license_id = source_license:gsub("license:", "")
	
	local String_format = '\n\n**Player Information:**\nName: %s\nIdentifier: %s```%s```\nDiscord: <@%s>```%s```\nLicense: `%s`'
	local message = String_format:format(source.getName(), GetPlayerName(sourceid), source.identifier,source_discord_id,source_discord_id,source_license_id)
	local embed = {
		{
            ["color"] = Config.Webhooks.Colors[TYPE],
            ["author"] = {
                ["icon_url"] = 'https://cdn.discordapp.com/attachments/1019968751619293194/1192369234622300281/FRP_gold.png',
                ["name"] = 'Familia Oil Rig - Log',
            },
			["title"] = '**'.. Config.Webhooks.Locale[TYPE] ..'**',
			["description"] = message,
            ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%S'),
		    ["footer"] = {
		        ["text"] = "Chan Scripts",
                ["icon_url"] = 'https://cdn.discordapp.com/attachments/1112335008678563960/1112383696771756113/1.png'
		    },
		}
	}
	PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({username = "Familia Log", embeds = embed}), { ['Content-Type'] = 'application/json' })
end