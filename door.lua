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
    create_door({
        id = 1,
        x = 64,
        y = 64,
        mapId = 1,
        destination_door_id = 2
    }),
    create_door({
        id = 2,
        x = 80,
        y = 40,
        mapId = 2,
        destination_door_id = 1,
        player_spawn_pos = "below"
    })
}

