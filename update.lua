function _update()
    if gamestate == "game" then
        update_player()

        -- game logic goes here
        -- check for 'x' button press to open menu
        if btnp(5) then
            gamestate = "menu"
        end
    elseif gamestate == "menu" then
        -- menu navigation
        if btnp(2) then
            menu_index -= 1
            if menu_index < 1 then
                menu_index = #menu
            end
        elseif btnp(3) then
            menu_index += 1
            if menu_index > #menu then
                menu_index = 1
            end
        end

        -- check for 'x' button press to select option
        if btnp(5) then
            -- handle option selection
            option_selected = menu[menu_index]
            -- for now, just print the selected option and switch back to game state
            printh(option_selected)
            if option_selected == "tALK" then
                -- check if player is near npc
                temp_npc = check_if_near_npc()
                if temp_npc then
                    temp_npc_name = temp_npc.name
                    -- if so, start dialogue
                    gamestate = "dialogue"
                    dialogue_index = 1
                end
            else
                gamestate = "game"
            end
        end
    elseif gamestate == "dialogue" then
        -- dialogue navigation
        update_dialogue()
    end
end


local char_speed = 20 -- characters printed per second
local char_count = 1
local timer = 0
local playing_sfx = false -- a flag to check if we've started the SFX for the current dialogue

function update_dialogue()
    -- increment the timer by the frame time (assuming 30 frames per second for PICO-8)
    timer += 1/30

    -- calculate how many characters should be displayed by now
    char_count = flr(char_speed * timer)

    -- If characters are still being typed and SFX isn't playing, play the SFX
    if char_count < #dialogues[temp_npc_name][dialogue_index] and not playing_sfx then
        sfx(0) 
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
                gamestate = "game" -- end dialogue after the last message
            end
        end
    end
end




function update_player()
    local dx, dy = 0, 0

    -- Calculate the direction of movement based on input
    if btn(0) then dx = -1 end
    -- left
    if btn(1) then dx = 1 end
    -- right
    if btn(2) then dy = -1 end
    -- up
    if btn(3) then dy = 1 end
    -- down

    if check_tile_collision(player, dx, dy) then
        -- If there's a collision, don't move the player and exit the function
        return
    end

    local door = check_door_collision()

    if door then
        dest_door = handle_door_transition(door)

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
    else
        -- If there are no collisions, move the player normally
        player.x = player.x + dx * player.speed
        player.y = player.y + dy * player.speed
    end

    -- print player position
    -- debug[0] = "player.x: " .. player.x .. ", player.y: " .. player.y
end