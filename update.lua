function _update()
    if gamestate == "game" then
        debug[0] = "game state activated!"
        update_player()

        -- game logic goes here
        -- check for 'x' button press to open menu
        if btnp(5) then
            gamestate = "menu"
        end
    elseif gamestate == "menu" then
        debug[0] = "menu state activated!"
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
                debug[1] = "temp_npc: " .. temp_npc.name
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
        debug[0] = "dialogue state activated!"
        -- dialogue navigation
        if btnp(5) or btnp(4) then
            debug[1] = "dialogue_index: " .. dialogue_index
            dialogue_index += 1
            if dialogue_index > #dialogues[temp_npc_name] then
                dialogue_index = 1
                gamestate = "game" -- end dialogue after the last message
            end
        end
    end
end

function update_menu()
    if btnp(2) then
        -- Up button
        menu_index = max(1, menu_index - 1)
    elseif btnp(3) then
        -- Down button
        menu_index = min(#menu_items, menu_index + 1)
    elseif btnp(5) then
        -- X button
        menu_items[menu_index].action()
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
        debug[1] = "door collision detected!"
        debug[2] = "This door is in: " .. door.curr_map
        debug[3] = "This door leads to: " .. door.lead_to
        -- curr_map = maps[door.link.map]
        -- player.x = door.link.x
        -- player.y = door.link.y + 8 -- 8 pixels below the door
    else
        debug[1] = ""
    end
    -- If there are no collisions, move the player
    player.x = player.x + dx * player.speed
    player.y = player.y + dy * player.speed
end