-- First, create both doors
base_door = {
    id = 0,
    spr = 88,
    x = 64,       -- Door's x position
    y = 64,       -- Door's y position
    top = 0,      -- Collision boundaries
    bot = 7,
    left = 0,
    right = 7,
    mapId = 0,  -- Current map's name or id
    destination_door_id = nil,     -- ID of the door where player will spawn
    player_spawn_pos = "above",  -- Where the player will spawn on map
}

function create_door(overrides)
    -- Create a new table by copying the base_door values
    local door = {}
    for k, v in pairs(base_door) do
        door[k] = v
    end

    -- Apply the overrides
    for k, v in pairs(overrides) do  -- We should be iterating over 'overrides' here
        door[k] = v
    end

    return door
end

doors = {
    
    create_door({ -- rowans front door map 1
        id = 1,
        x = 64,
        y = 64,
        mapId = 1,
        destination_door_id = 2
    }),
    create_door({ -- rowans front door map 2
        id = 2,
        x = 72,
        y = 40,
        mapId = 2,
        destination_door_id = 1,
        player_spawn_pos = "below"
    }),
    
    create_door({ -- map 2 to map 3
        id = 3,
        x = 40,
        y = 8,
        mapId = 2,
        destination_door_id = 4,
        player_spawn_pos = "below"
    }),
    create_door({ -- map 3 to map 2
        id = 4,
        x = 64,
        y = 112,
        mapId = 3,
        destination_door_id = 3,
    }),
    
    create_door({ -- map 3 to Dungeon
        id = 5,
        x = 64,
        y = 64,
        mapId = 3,
        destination_door_id = 6,
        player_spawn_pos = "below"
    }), 
    create_door({ -- dungeon to map 3
        id = 6, -- do not change please or everything will break
        x = 32,
        y = 32,
        mapId = 100,
        destination_door_id = 5,
        player_spawn_pos = "below"
    }),
    
    create_door({ -- map 2 to outside
        id = 7,
        x = 56,
        y = 104,
        mapId = 2,
        destination_door_id = 8,
        player_spawn_pos = "above"
    }),
    create_door({ -- outside to map 2
        id = 8,
        x = 72,
        y = 16,
        mapId = 4,
        destination_door_id = 7,
        player_spawn_pos = "below"
    }),

    create_door({ -- outside to mountainside
        id = 9,
        spr = 84, -- sand
        x = 0,
        y = 80,
        mapId = 4,
        destination_door_id = 10,
        player_spawn_pos = "right"
    }),
    create_door({ -- mountainside to outside
        id = 10,
        spr = 84, -- sand
        x = 120,
        y = 80,
        mapId = 5,
        destination_door_id = 9,
        player_spawn_pos = "left"
    }),
    
    create_door({ -- mountainside to Megito Gate
        id = 11,
        spr = 84, -- sand
        x = 8,
        y = 72,
        mapId = 5,
        destination_door_id = 12,
        player_spawn_pos = "right"
    }),
    create_door({ -- Megito Gate to Mountain Side
        id = 12,
        spr = 84, -- sand
        x = 120,
        y = 72,
        mapId = 6,
        destination_door_id = 11,
        player_spawn_pos = "left"
    }),

    create_door({ -- Dungeon to Final Room
        id = 13,
        x = 32 + 2,
        y = 32 + 2,
        mapId = 100,
        destination_door_id = 14,
        player_spawn_pos = "below"
    }),
    create_door({ -- Final Room to Dungeon
        id = 14,
        x = 64,
        y = 64,
        mapId = 7,
        destination_door_id = 13,
        player_spawn_pos = "below"
    }),
}

