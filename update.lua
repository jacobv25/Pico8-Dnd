function _update()
    debug[0] = "active map: " .. active_map
    if gamestate == "game" then
        update_player()
        update_animation(player)
        -- game logic goes here
        -- check for 'x' button press to open menu
        if btnp(5) then
            gamestate = "menu"
        end
    elseif gamestate == "menu" then
        local current_index = item_submenu and item_index or menu_index
        local current_menu = item_submenu and items or menu

        if btnp(2) then
            current_index -= 1
            if current_index < 1 then
                current_index = #current_menu
            end
        elseif btnp(3) then
            current_index += 1
            if current_index > #current_menu then
                current_index = 1
            end
        end

        if item_submenu then
            item_index = current_index
        else
            menu_index = current_index
        end

        -- check for 'x' button press to select option
        if btnp(5) then
            if item_submenu then
                -- handle item usage (will implement later)
                debug[2] = "Used " .. items[item_index]
                item_submenu = false
            else
                option_selected = menu[menu_index]
                debug[3] = option_selected
                if option_selected == "tALK" then
                    -- check if player is near npc
                    temp_npc = check_if_near_npc()
                    if temp_npc then
                        temp_npc_name = temp_npc.name
                        -- if so, start dialogue
                        stop_music()
                        gamestate = "dialogue"
                        dialogue_index = 1
                    end
                elseif option_selected == "iTEM" then
                    item_submenu = true
                else
                    play_music_for_map(active_map)
                    gamestate = "game"
                end
            end
        end
    elseif gamestate == "dialogue" then
        -- dialogue navigation
        update_dialogue()
    end
end

-- update the animation state
function update_animation(anim_obj)
    anim_obj.timer += 1
    if anim_obj.timer >= anim_obj.animations[anim_obj.current_anim].speed then
        anim_obj.timer = 0
        anim_obj.current_frame += 1
        if anim_obj.current_frame > #anim_obj.animations[anim_obj.current_anim].frames then
            anim_obj.current_frame = 1
        end
    end
end

local char_speed = 20 -- characters printed per second
local char_count = 1
local timer = 0
local playing_sfx = false -- a flag to check if we've started the SFX for the current dialogue

function update_dialogue()
    -- increment the timer by the frame time (assuming 30 frames per second for PICO-8)
    timer += 1 / 30

    -- calculate how many characters should be displayed by now
    char_count = flr(char_speed * timer)

    -- If characters are still being typed and SFX isn't playing, play the SFX
    if char_count < #dialogues[temp_npc_name][dialogue_index] and not playing_sfx then
        sfx(40)
        playing_sfx = true
    end

    -- If characters are done typing, stop the SFX and reset the flag
    if char_count >= #dialogues[temp_npc_name][dialogue_index] and playing_sfx then
        -- Assuming sfx -1 stops all sound effects
        sfx(-1)
        playing_sfx = false
    end

    -- check for 'x' button press to advance dialogue
    if btnp(5) or btnp(4) then
        if char_count < #dialogues[temp_npc_name][dialogue_index] then
            char_count = #dialogues[temp_npc_name][dialogue_index] -- instantly display the whole text
        else
            dialogue_index += 1
            char_count = 1
            timer = 0 -- reset the timer
            playing_sfx = false -- reset the SFX flag
            if dialogue_index > #dialogues[temp_npc_name] then
                dialogue_index = 1
                play_music_for_map(active_map)
                gamestate = "game" -- end dialogue after the last message
            end
        end
    end
end

function update_player()
    local dx, dy = 0, 0

    if btn(0) then
        dx = -player.speed
        player.current_anim = "walk_left"
    elseif btn(1) then
        dx = player.speed
        player.current_anim = "walk_right"
    elseif btn(2) then
        dy = -player.speed
        player.current_anim = "walk_up"
    elseif btn(3) then
        dy = player.speed
        player.current_anim = "walk_down"
    else
        player.current_anim = "idle"
    end

    if active_map == PROC_GEN_MAP_ID then
        if check_tile_collision_for_proc_gen_map(player, dx, dy) then
            -- If there's a collision, don't move the player and exit the function
            return
        end

        -- handle any door collisions
        local x, y = get_tile_under_player()

        if x == 32 and y == 32 then
            dest_door = handle_door_transition(doors[6])
            -- Move player to the new position
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
        -- If there are no collisions, move the player normally
        player.x = player.x + dx * player.speed
        player.y = player.y + dy * player.speed
    else
        if check_tile_collision(player, dx, dy) then
            -- If there's a collision, don't move the player and exit the function
            return
        end

        local door = check_door_collision()

        if door then
            dest_door = handle_door_transition(door)
            if dest_door then
                -- handle door transition to proc gen map
                if dest_door.id == 6 then
                    -- assume we always want to draw the player right of the door
                    player.y = dest_door.y * 8 - GRID_SIZE
                    player.x = dest_door.x * 8
                else
                    -- handle normal transition
                    -- Move player to the new position
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
            end
        else
            -- If there are no collisions, move the player normally
            player.x = player.x + dx * player.speed
            player.y = player.y + dy * player.speed
        end
    end
end