Config = {}

notify = function(data)	
	lib.notify({                              --ex -- notify({des = '',status =''})
		title = 'OilRig Owner!',  --Replace your Notification function here
		description = data.des,
        type = data.status,
		position = 'top',
        duration = 6000,
		
	})
end

Config.RequiredCopsCount = 0  --Required Cop Count to trigger the robbery
Config.cooldown_time = 45 --Cooldown in Minutes to trigger the robbery again
Config.debug = true --Make this true if you want to show the zones
Config.hackLocation = vec3(-2055.613281, -1027.608765, 3.289722)  

Config.robberystart_item ='water'

Config.hackTimer = 10000
Config.PumpTimer = 10000
Config.SearchTimer = 10000
Config.EasterEggTimer = 10000

--Location Where you should talk with the ped to start the robbery
Config.oilrig_ped = {
    model = 's_m_m_highsec_01',
    scenario = 'WORLD_HUMAN_SMOKING',
    location = vector3(-182.6217, 6551.0503, 10.0978),
    heading =  25.3951,
    distance = 40.0,
    target_label = 'Bribe Me!',
	target_icon = 'fa-solid fa-oil-well'
}

--The NPC'S spawn location incase your using any other OilRigs you can use this configuration to change the ped locations
Config.Mission = {
    NPCModel = 'g_m_y_lost_02', --NPC Name
    NPCLocations = { --NPC's location in vector 4
        -- 1st Floor (8 Bots)
        vec4(-944.4282, 7475.8931, 28.0420, 253.9047),
        vec4(-942.0003, 7485.1260, 28.0420, 245.1713),
        vec4(-939.7184, 7494.9590, 28.0420, 203.0469),
        vec4(-932.8174, 7501.5239, 28.0420, 206.7144),
        vec4(-919.2621, 7499.8340, 28.0420, 167.6440),
        vec4(-904.4490, 7497.0791, 28.0420, 173.3403),
        vec4(-897.3665, 7487.1294, 28.0420, 153.4286),
        vec4(-898.6198, 7473.0845, 28.0420, 119.2375),
        -- 1st floor Room(3 Bots):
        vec4(-919.3779, 7485.2856, 28.0420, 195.1239),
        vec4(-905.5021, 7478.2461, 28.0420, 101.3180),
        vec4(-909.1107, 7487.4614, 39.9363, 185.3163),
        -- 2nd Floor(9 Bots):
        vec4(-913.8435, 7473.7017, 43.5841, 332.3127),
        vec4(-942.4855, 7456.7935, 43.5841, 285.7958),
        vec4(-908.6139, 7450.5898, 43.5841, 67.0038),
        vec4(-920.5746, 7472.6416, 43.5841, 164.0193),
        vec4(-893.6834, 7464.4375, 43.5841, 256.5750),
        vec4(-895.3876, 7482.9653, 43.5841, 250.4105),
        vec4(-900.4843, 7490.3970, 43.5841, 325.4352),
        vec4(-929.6627, 7498.8745, 43.5841, 160.1714),
        vec4(-935.9771, 7491.8198, 43.5841, 252.7127)
    },
}

Config.SearchLocations = {
    [1] = { --You can add Multiple Zones and when player searches all the zones it will provide a final reward if you want, I have also setup rewards for every single search
        num = 1,
        coords = vec3(-907.7, 7493.7, 44.0),
        size = vec3(1.3, 0.9, 2.4),
        rotation = 349.0,
        anim = {
            dict = 'mini@triathlon',
            clip = 'rummage_bag'
        },
        reward_items = {
            [1] = {item = 'black_money', count = 13000}, --Add the next and continue for more
        }
    },
}

Config.Finishreward = {
    [1] = {item = 'weedbrick', count = 1},
    [2] = {item = 'methbrick', count = 1},
    [3] = {item = 'smg_blueprint', count = 2},
    [4] = {item = 'smg_tact', count = 2},
    [5] = {item = 'smg_frame', count = 2},
}

Config.Dielocation = vec3(20.6640, 7640.8706, 17.3110)  --If you die you will respawn in a remote location you can change that location here.

Config.DiscordWebhook = '' --Place your Discord Webhook here

Config.Webhooks = {
    Locale = {
        ['robberyProcess'] = '⌛ Robbery started...',
        ['robberyFinished'] = '✅ Robbery finished.',
        ['robberyCanceled'] = '❌ Robbery Canceled..',
    },

    -- To change a webhook color you need to set the decimal value of a color, you can use this website to do that - https://www.mathsisfun.com/hexadecimal-decimal-colors.html
    Colors = {
        ['robberyProcess'] = 3145631, 
        ['robberyFinished'] = 3093151,
        ['robberyCanceled'] = 16711680,
    }
}