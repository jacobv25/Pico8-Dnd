function _draw()
    cls()
    draw_map()
    draw_player()
    draw_npcs()
    draw_doors()
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

function draw_npcs()
    for i = 1, #npcs do
        local npc = npcs[i]
        spr(npc.spr, npc.x, npc.y)
    end
end

function draw_doors()
    for i = 1, #doors do
        local door = doors[i]
        spr(door.spr, door.x, door.y)
    end
end

function draw_player()
    -- Draw player
    spr(player.spr, player.x, player.y)
end

function draw_map()
    map(current_room_x, current_room_y)
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

    -- draw the dialogue
    print(dialogues[npc_name][dialogue_index], border_x + 10, border_y + 10, 7)
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

    -- draw the menu
    for i = 1, #menu do
        local color = 6 -- default color
        if i == menu_index then
            print(">" .. menu[i], border_x + 10, border_y + 10 + (i - 1) * 10, 7) -- selected item is white
        else
            print(menu[i], border_x + 10, border_y + 10 + (i - 1) * 10, color) -- other items are lighter
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