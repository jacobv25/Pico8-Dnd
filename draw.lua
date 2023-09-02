function _draw()
    cls()
    if active_map == PROC_GEN_MAP_ID then
        beforedraw()

        draw_proc_gen_map(heightmap)
        -- draw the player
        local frame = player.animations[player.current_anim].frames[player.current_frame]
        spr(frame, 64, 64)

        afterdraw()

    else
        draw_map()
        draw_doors()
        draw_animation(player)
        draw_npcs()
    end
    draw_debug()
    if gamestate == "menu" then
        draw_menu()
    elseif gamestate == "game" then
        -- do something
    elseif gamestate == "dialogue" then
        -- draw the dialogue
        draw_dialogue(temp_npc_name)
    end
end

function beforedraw()
    myx = 64
    myy = 64
    -- myr = flr(32+sin(time()/8)*32)
    myr = 8
    clip(myx-myr,myx-myr,myr*2+1,myr*2+1)

end

function afterdraw()
    palt(0,false)

    local py=myy-myr
    for px=myx-myr, myx+myr do
        local cval=px -(myx-myr)
        cval=cval/(myr*2)
        cval=cval*2-1
        cval=1-sqrt(1-cval*cval)
        local ph=cval*myr+0.1
        line(px,py,px,py+ph,0)
        line(px,py+myr*2-ph,px,py+myr*2,0)
    end

    palt()
end



-- draw the current frame
function draw_animation(anim_obj)
    local frame = anim_obj.animations[anim_obj.current_anim].frames[anim_obj.current_frame]
    spr(frame, anim_obj.x, anim_obj.y)
end

function draw_npcs()
    for i = 1, #npcs do
        local npc = npcs[i]
        if npc.curr_map == active_map then
            spr(npc.spr, npc.x, npc.y)
        end
    end
end

function draw_doors()
    -- print size of doors
    for i = 1, #doors do
        local door = doors[i]
        if door.mapId == active_map then
            spr(door.spr, door.x, door.y)
        end
    end
end

function draw_player()
    -- Draw player
    spr(player.spr, player.x, player.y)
end

function draw_map()
    map(current_room_x, current_room_y)
end

local screen_center_x = 64
local screen_center_y = 64
local offset_x = 0
local offset_y = 0

function draw_proc_gen_map(heightmap)
    screen_center_x = 64
    screen_center_y = 64

    offset_x = screen_center_x - player.x
    offset_y = screen_center_y - player.y

    for y = 1, proc_gen_map_height do
        for x = 1, proc_gen_map_width do
            if doors[6].x == x and doors[6].y == y then
                -- draw special door
                spr(doors[6].spr, x * 8 - 8 + offset_x, y * 8 - 8 + offset_y)
            else
                --draw proc gen map
                local value = heightmap[x][y]

                local tile_id
                if value <= 2 then
                    tile_id = WATER_SPRITE -- water sprite
                elseif value < 6 then
                    tile_id = LAND_SPRITE -- land sprite
                else
                    tile_id = MOUNTAIN_SPRITE -- mountain sprite
                end

                spr(tile_id, x * 8 - 8 + offset_x, y * 8 - 8 + offset_y)
            end
        end
    end
end

function draw_dialogue(npc_name)
    -- draw a border around the dialogue
    local border_x = 30
    local border_y = 30
    local border_width = 90
    local border_height = 60

    -- filled rect for background
    rectfill(border_x, border_y, border_x + border_width, border_y + border_height, 0)
    -- background is black

    -- border line
    rect(border_x, border_y, border_x + border_width, border_y + border_height, 7)
    -- border is white

    -- get the substring to display
    local display_text = sub(dialogues[npc_name][dialogue_index], 1, char_count)

    -- draw the dialogue
    print(display_text, border_x + 10, border_y + 10, 7)
    -- dialogue text is white
end

function draw_menu()
    -- draw a border around the menu
    local border_x = 30
    local border_y = 30
    -- adjusted to center the menu vertically
    local border_width = 90
    local border_height = 60
    -- adjusted to better fit the centered menu
    rectfill(border_x, border_y, border_x + border_width, border_y + border_height, 1)
    -- filled rect for background
    rect(border_x, border_y, border_x + border_width, border_y + border_height, 7)
    -- border line

    local display_menu = menu

    if item_submenu then
        display_menu = items
    end

    for i = 1, #display_menu do
        local color = 6 -- default color
        local index = item_submenu and item_index or menu_index
        if i == index then
            print(">" .. display_menu[i], border_x + 10, border_y + 10 + (i - 1) * 10, 7) -- selected item is white
        else
            print(display_menu[i], border_x + 10, border_y + 10 + (i - 1) * 10, color) -- other items are lighter
        end
    end
end
-- Function to draw debug information
function draw_debug()
    for line_number, text in pairs(debug) do
        local y_coordinate = line_number * 6 -- Each line is 6 pixels apart
        print(text, 0, y_coordinate, 7)
    end
end