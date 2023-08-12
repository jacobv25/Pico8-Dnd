function check_if_near_npc()
    for i, npc in ipairs(npcs) do
        if active_map == npc.curr_map and check_collision(player, npc) then
            -- A collision has been detected, return the NPC
            return npc
        end
    end
    -- No collisions were detected, return nil
    return nil
end

function check_tile_collision(player, dx, dy)
    -- Calculate the player's new position
    local new_x = player.x + dx * player.speed
    local new_y = player.y + dy * player.speed

    -- Calculate the coordinates of the four corners of the player sprite
    local corners = {
        { x = new_x + player.left, y = new_y + player.top }, -- top-left
        { x = new_x + player.right, y = new_y + player.top }, -- top-right
        { x = new_x + player.left, y = new_y + player.bot }, -- bottom-left
        { x = new_x + player.right, y = new_y + player.bot } -- bottom-right
    }

    -- Check each corner for a collision
    for i, corner in ipairs(corners) do
        local tile_x = flr(corner.x / 8) -- assuming each tile is 8x8 pixels
        local tile_y = flr(corner.y / 8)
        local tile_number = mget(tile_x, tile_y)

        for j, non_walkable_tile in ipairs(non_walkable) do
            if tile_number == non_walkable_tile then
                return true
            end
        end
    end

    -- No collisions were found
    return false
end

-- This function checks if two rectangles overlap (collide)
function check_collision(a, b)
    local a_left = a.x + a.left
    local a_right = a.x + a.right
    local a_top = a.y + a.top
    local a_bottom = a.y + a.bot

    local b_left = b.x + b.left
    local b_right = b.x + b.right
    local b_top = b.y + b.top
    local b_bottom = b.y + b.bot

    -- Check if a is to the right of b
    if a_left > b_right then
        return false
    end
    -- Check if a is to the left of b
    if a_right < b_left then
        return false
    end
    -- Check if a is below b
    if a_top > b_bottom then
        return false
    end
    -- Check if a is above b
    if a_bottom < b_top then
        return false
    end

    -- If none of the above conditions are true, rectangles must be colliding
    return true
end

function check_door_collision()
    for i, door in ipairs(doors) do
        if door.mapId == active_map and check_collision(player, door) then
            -- A collision has been detected with a door on the active map, return the door
            return door
        end
    end
    -- No collisions were detected, return nil
    return nil
end


function handle_door_transition(door)
    -- Find the destination door
    local dest_door = nil
    for i = 1, #doors do
        if doors[i].id == door.destination_door_id then
            dest_door = doors[i]
            break
        end
    end

    if not dest_door then
        -- Handle the case where there's no destination door found
        debug[2] = "No destination door found"
        return
    end

    -- Load the new map
    -- Assuming you have some kind of load_map() function:
    load_map(dest_door.mapId)

    return dest_door
end

function load_map(mapId)
    local map_data = nil
    for i = 1, #maps do
        if maps[i].id == mapId then
            map_data = maps[i]
            break
        end
    end
    
    if map_data then
        current_room_x = map_data.cell_x
        current_room_y = map_data.cell_y
        active_map = mapId
    else
        -- Handle the case where the map ID is invalid
        debug[3] = "Invalid map ID: "..mapId
    end
end
