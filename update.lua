function _update()
    -- debug[0] = "active map: " .. active_map
    if gamestate == "game" then
        update_player()
        update_animation(player)
        if torch_activation_time and torchActive then
            debug[1] = "Torch time: " .. time() - torch_activation_time
        end
        -- If torch is active and the duration is exceeded, deactivate it
        if torchActive and time() - torch_activation_time > torch_duration then
            debug[1] = "Torch deactivated"
            -- print the torch time
            torchActive = false
        end
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
                if items[item_index] == nil then
                    gamestate = "game"
                    item_submenu = false
                    return
                end
                debug[2] = "Used " .. items[item_index]

                if items[item_index] == "Torch" then
                    del(items, "Torch")
                    torchActive = true
                    gamestate = "game"
                    torch_activation_time = time()
                end

                item_submenu = false
            else
                option_selected = menu[menu_index]
                -- debug[3] = option_selected
                -- TALK MENU ITEM SELECTED
                if option_selected == "tALK" then
                    -- check if player is near npc
                    temp_npc = check_if_near_npc()
                    if temp_npc then
                        temp_npc_name = temp_npc.name

                        if temp_npc.item then
                        end
                        -- if so, start dialogue
                        stop_music()
                        gamestate = "dialogue"
                        dialogue_index = 1
                    end
                    -- ITEM MENU ITEM SELECTED
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
    elseif gamestate == "final" then
        -- ****** FINAL CUTSENE LOGIC ******
        -- MOVE PLAYER
        -- update the interpolation factor, ensuring it doesn't exceed 1
        player.t = min(player.t + player.speed / 100, 1)

        -- update the player's position using lerp
        player.x = lerp(player.x, player.target_x, player.t)
        player.y = lerp(player.y, player.target_y, player.t)

        -- player has reached target
        if player.x == player.target_x and player.y == player.target_y then
            -- do something
            laserE.on = true
            laserbeam(0, 120, 48, 80, 10, 30, 30)
            laserE.t += 1
            for p in all(laserE.parts) do
                dolaserbeam_part(p)
            end
        end
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

    -- debug[1] = "temp_npc_name: " .. temp_npc_name
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
                -- END OF DIALOGUE
                dialogue_index = 1
                play_music_for_map(active_map)
                --CHECK IF NPC IS SPECIAL
                -- iterate through all the npcs and get the npc whose name matches temp_npc_name
                for i = 1, #npcs do
                    if npcs[i].name == temp_npc_name then
                        -- if the npc has an item, add it to the player's inventory
                        if npcs[i].item then
                            add(items, npcs[i].item)
                        end
                        break
                    end
                end

                -- if temp_npc_name equals "eli" then switch to "final" gamestate
                if temp_npc_name == "eli" then
                    -- debug[2] = "in final state"
                    gamestate = "final"
                else
                    gamestate = "game"
                end
            end
        end
    end
end