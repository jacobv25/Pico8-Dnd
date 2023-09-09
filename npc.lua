base_npc = {
    name = "default",
    spr = 0,
    x = 64,
    y = 64,
    top = -7,
    bot = 15,
    left = -7,
    right = 15,
    curr_map = 0
}

-- This function creates a new NPC based on the base NPC and an overrides table
function create_npc(overrides)
    -- Create a new table by copying the base_npc
    local npc = {}
    for k, v in pairs(base_npc) do
        npc[k] = v
    end

    -- Apply the overrides
    for k, v in pairs(overrides) do
        npc[k] = v
    end

    return npc
end
npcs = {
    create_npc({ name = "rowan", x = 50, y = 40, spr = 24, curr_map = 1 }),
    create_npc({ name = "fintan", x = 40, y = 50, spr = 40, curr_map = 2 }),
    create_npc({ name = "saksham", x = 80, y = 80, spr = 56, curr_map = 2 }),
    create_npc({ name = "robie", x = 72, y = 72, spr = 8, curr_map = 3 }),
    create_npc({ name = "trader", x = 64, y = 32, spr = 42, curr_map = 6 }),
    create_npc({ name = "gate-guard", x = 40, y = 48, spr = 26, curr_map = 6 }),
    create_npc({ name = "eli", x = 64, y = 48, spr = 10, curr_map = 7 })
}

local eli_face = {
 {203, 204, 205, 206},
 {219, 220, 221, 222},
 {235, 236, 237, 238},
 {251, 252, 253, 254}
}