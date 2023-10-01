player = {
    spr = 1,
    spr2 = 3,
    x = 50,
    y = 64,
    top = 1,
    bot = 7,
    left = 2,
    right = 5,
    speed = 1,
    animations = {
        idle = {frames={128,129,130,131}, speed=15},
        walk_right = {frames={132,133,134,135}, speed=5},
        walk_left = {frames={136,137,138,139}, speed=5},
        walk_up = {frames={140,141,142,143}, speed=5},
        walk_down = {frames={144,145,146,147}, speed=5}
    },
    current_anim = "idle",
    current_frame = 1,
    timer = 0,
    r = 32,
    --lerp
    target_x = 100,  -- destination x-coordinate
    target_y = 100,  -- destination y-coordinate
    t = 0  -- interpolation factor, initialize to 0
}


function handle_door_transition_and_move(dest_door)
    if dest_door.player_spawn_pos == "left" then
        player.x = dest_door.x - GRID_SIZE
    elseif dest_door.player_spawn_pos == "right" then
        player.x = dest_door.x + GRID_SIZE
    elseif dest_door.player_spawn_pos == "above" then
        player.y = dest_door.y - GRID_SIZE
        player.x = dest_door.x
    elseif dest_door.player_spawn_pos == "below" then
        player.y = dest_door.y + GRID_SIZE
        player.x = dest_door.x
    end
end

function update_player()
    local dx, dy = 0, 0

    local anims = {
        [0] = "walk_left",
        [1] = "walk_right",
        [2] = "walk_up",
        [3] = "walk_down"
    }

    for k, v in pairs(anims) do
        if btn(k) then
            dx = (k == 1 and player.speed or (k == 0 and -player.speed or 0))
            dy = (k == 3 and player.speed or (k == 2 and -player.speed or 0))
            player.current_anim = v
            break
        end
    end

    if not dx and not dy then
        player.current_anim = "idle"
    end

    if active_map == PROC_GEN_MAP_ID then
        if check_tile_collision_for_proc_gen_map(player, dx, dy) then
            return
        end

        local x, y = get_tile_under_player()

        if (x == 32 and y == 32) or (x == 34 and y == 34) then
            local door_index = (x == 32) and 6 or 13
            dest_door = handle_door_transition(doors[door_index])
            handle_door_transition_and_move(dest_door)
        else
            player.x = player.x + dx * player.speed
            player.y = player.y + dy * player.speed
        end

    else
        if check_tile_collision(player, dx, dy) then
            return
        end

        local door = check_door_collision()

        if door then
            dest_door = handle_door_transition(door)
            if dest_door then
                if dest_door.id == 6 then
                    player.y = dest_door.y * 8 - GRID_SIZE
                    player.x = dest_door.x * 8
                else
                    handle_door_transition_and_move(dest_door)
                end
            end
        else
            player.x = player.x + dx * player.speed
            player.y = player.y + dy * player.speed
        end
    end
end


function draw_player()
    -- Draw player
    spr(player.spr, player.x, player.y)
end