-- First, create both doors
base_door = {
    spr = 88,
    x = 64,
    y = 64,
    top = 0,
    bot = 7,
    left = 0,
    right = 7,
    curr_map = "BAD_VALUE",
    lead_to = "BAD_VALUE",
    spawn_player = "BAD_VALUE"
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
        spr = 88,
        x = 64,
        y = 64,
        curr_map = "rowans_house",
        lead_to = "outside_rowans_house",
        spawn_player = "above"
    }),
    -- create_door({
    --     x = 64,
    --     y = 64,
    --     curr_map = "cavea lieter",
    --     lead_to = "inside_rowans_house",
    --     spawn_player = "below"
    -- })
}

