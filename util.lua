function check_if_near_npc()
    for i, npc in ipairs(npcs) do
        if check_collision(player, npc) then
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
        if check_collision(player, door) then
            -- A collision has been detected, return the door
            return door
        end
    end
    -- No collisions were detected, return nil
    return nil
end