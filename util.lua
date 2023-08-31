function stop_music()
    music(-1)
    current_music = nil
    -- No music is playing now
end


-- Helper function to check if a value is in a list
function in_list(val, list)
    for _, v in pairs(list) do
        if v == val then
            return true
        end
    end
    return false
end

current_music = nil -- This will store the current music range (start and stop) if any is playing

function play_music_for_map(map)
    for group, data in pairs(map_music) do
        if in_list(map, data.maps) then
            -- If the same music is already playing, decide whether to restart based on "force_restart_on"
            if current_music == group and (not data.force_restart_on or not in_list(map, data.force_restart_on)) then
                return -- Music is already playing and doesn't need to restart
            end

            music(data.start, data.stop, 7)
            current_music = group -- Store the music group as the currently playing music
            return
        end
    end

    -- If we've reached here, no music mapping was found for the map, so stop any playing music
    stop_music()
end

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

function check_tile_collision_for_proc_gen_map(player, dx, dy)
    local new_x = player.x + dx * player.speed
    local new_y = player.y + dy * player.speed

    local corners = {
        { x = new_x + player.left, y = new_y + player.top }, 
        { x = new_x + player.right, y = new_y + player.top }, 
        { x = new_x + player.left, y = new_y + player.bot }, 
        { x = new_x + player.right, y = new_y + player.bot }
    }

    for i, corner in ipairs(corners) do
        local tile_x = flr(corner.x / 8) + 1
        local tile_y = flr(corner.y / 8) + 1
        
        if tile_x < 1 or tile_x > #proc_gen_world_map[1] or tile_y < 1 or tile_y > #proc_gen_world_map then
            return true
        end

        local tile_number = proc_gen_world_map[tile_y][tile_x]

        for _, non_walkable_tile in ipairs(proc_gen_non_walkable) do
            if tile_number == non_walkable_tile then
                return true
            end
        end
    end
    return false
end

function check_tile_collision(player, dx, dy)
    -- Calculate the player's new position
    local new_x = player.x + dx * player.speed
    local new_y = player.y + dy * player.speed

    -- Get the active map's offset
    local map_offset_x = maps[active_map].cell_x * 8
    -- assuming each cell is equivalent to a 8x8 tile
    local map_offset_y = maps[active_map].cell_y * 8

    -- Calculate the coordinates of the four corners of the player sprite
    local corners = {
        { x = new_x + player.left, y = new_y + player.top }, -- top-left
        { x = new_x + player.right, y = new_y + player.top }, -- top-right
        { x = new_x + player.left, y = new_y + player.bot }, -- bottom-left
        { x = new_x + player.right, y = new_y + player.bot } -- bottom-right
    }

    -- Check each corner for a collision
    for i, corner in ipairs(corners) do
        local tile_x = flr((corner.x + map_offset_x) / 8) -- Adjusted to account for map offset
        local tile_y = flr((corner.y + map_offset_y) / 8) -- Adjusted to account for map offset
        local tile_number = mget(tile_x, tile_y)
        debug[9] = "Tile number: " .. tile_number
        for j, non_walkable_tile in ipairs(maps[active_map].non_walkable) do
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
    if mapId == PROC_GEN_MAP_ID then
        -- Reset player position if needed, or set to a starting position
        player.x, player.y = 64, 64  -- example: start in the middle of the procedural map

        current_room_x = 0
        current_room_y = 16
        active_map = PROC_GEN_MAP_ID
        play_music_for_map(active_map)  -- if you have specific music for the procedural map

    else
        -- The existing logic for your hand-drawn maps
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
            play_music_for_map(active_map)
        else
            -- Handle the case where the map ID is invalid
            debug[3] = "Invalid map ID: " .. mapId
        end
    end
end

function get_tile_under_player()
    local tile_x = flr(player.x / 8) + 1
    local tile_y = flr(player.y / 8) + 1

    return tile_x, tile_y
end
