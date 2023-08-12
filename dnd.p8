pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
debug = {}
#include door.lua
local GRID_SIZE = 8
player = {
    spr = 1,
    spr2 = 3,
    x = 50,
    y = 64,
    top = 1,
    bot = 7,
    left = 2,
    right = 5,
    speed = 1
}

base_npc = {
    name = "default",
    spr = 0,
    x = 64,
    y = 64,
    top = -7,
    bot = 15,
    left = -7,
    right = 15,
    curr_map = 0
}

-- This function creates a new NPC based on the base NPC and an overrides table
function create_npc(overrides)
    -- Create a new table by copying the base_npc
    local npc = {}
    for k, v in pairs(base_npc) do
        npc[k] = v
    end

    -- Apply the overrides
    for k, v in pairs(overrides) do
        npc[k] = v
    end

    return npc
end
-- Now you can create a new NPC with some fields changed
-- local npc1 = create_npc({x = 100, y = 100, top = 10})
npcs = {
    create_npc({ name = "rowan", x=50, y=40, spr=24, curr_map=1 }),
    create_npc({ name = "fintan", x=40, y=50, spr=40, curr_map=2}),
    create_npc({ name = "saksham", x=80, y=80, spr=56, curr_map=2})
}

-- define menu options
menu = { "tALK", "sEARCH", "iTEM", "sPELL", "eQUIP" }
menu_index = 1 -- Start the menu with the first item selected

#include dialogues.lua

maps = {
    {
        id = 1,
        name = "rowans_house",
        cell_x = 0,
        cell_y = 0,
        non_walkable = {96, 97, 112, 113}
    },
    {
        id = 2,
        name = "cavea_lieter",
        cell_x = 16, -- example, starting from cell 16 on the x-axis
        cell_y = 0,
        non_walkable = {96, 97, 112, 113, 64, 65, 80, 81}
    }
    -- ... other maps ...
}
active_map = maps[1].id -- Start the game in the first map
current_room_x = 0
current_room_y = 0
curr_map = 0

gamestate = "game" -- Start the game in the game state
pxl_mvmt_on = false

#include update.lua
#include draw.lua
#include util.lua



__gfx__
00677700062222000044446000000000000000000000000000000000000000004433334444333344000000000000000000000000000000000000000000000000
00677700062ff2000044446000000000000000000000000000000000000000004453534444353544000000000000000000000000000000000000000000000000
00677700062222000044446000000000000000000000000000000000000000004433334444333344000000000000000000000000000000000000000000000000
05677770060226866864406000000000000000000000000000000000000000004443344444433444000000000000000000000000000000000000000000000000
05677760666228888884466600000000000000000000000000000000000000004433334444333344000000000000000000000000000000000000000000000000
05577650060226866864406000000000000000000000000000000000000000004433334444333344000000000000000000000000000000000000000000000000
00566600060220600644406000000000000000000000000000000000000000004433334444333344000000000000000000000000000000000000000000000000
00555500002222000044440000000000000000000000000000000000000000004433334444333344000000000000000000000000000000000000000000000000
0000000000ccccc00ccccc00000000000000000000000000000000000000000044aaaa4444aaaa44441111440000000000000000000000000000000000000000
0000000000ccccc00ccccc000000000000000000000000000000000000000000447f7a4444a7f744441111440000000000000000000000000000000000000000
0000000000555cc00cc55500000000000000000000000000000000000000000044affa4444affa44441111440000000000000000000000000000000000000000
0000000000ccccc00ccccc00000000000000000000000000000000000000000044aeea4444aeea44444114440000000000000000000000000000000000000000
0000000000cccbc00cbccc000000000000000000000000000000000000000000444ee444444ee444441111440000000000000000000000000000000000000000
0000000000ccc4c00c4ccc00000000000000000000000000000000000000000044eeee4444eeee44441111440000000000000000000000000000000000000000
000000000cccc4c00c4cccc0000000000000000000000000000000000000000044eeee4444eeee44441111440000000000000000000000000000000000000000
000000000dddddd00dddddd0000000000000000000000000000000000000000044eeee4444eeee44441111440000000000000000000000000000000000000000
000000000555550000555550000000000000000000000000000000000000000044aaaa4444aaaa44000000000000000000000000000000000000000000000000
0000000006161600006161600000000000000000000000000000000000000000447f7f4444f7f744000000000000000000000000000000000000000000000000
000000000555550000555550000000000000000000000000000000000000000044ffff4444ffff44000000000000000000000000000000000000000000000000
00000000005550000005550000000000000000000000000000000000000000004441144444411444000000000000000000000000000000000000000000000000
00000000005550000005550000000000000000000000000000000000000000004411114444111144000000000000000000000000000000000000000000000000
00000000005550000005550000000000000000000000000000000000000000004411114444111144000000000000000000000000000000000000000000000000
00000000005550000005550000000000000000000000000000000000000000004411114444111144000000000000000000000000000000000000000000000000
00000000055555000055555000000000000000000000000000000000000000004411114444111144000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000004444444444444444000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000004444444444444444000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000004444444444444444000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000004479794444979744000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000004499994444999944000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000004449944444499444000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000004449944444499444000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000004449944444499444000000000000000000000000000000000000000000000000
55555555555555555555555666555555444444444444444444444444511111154455555555555544044444440000000000000000000000000000000000000000
55566655555555555555556666665555444444444444454444455444511111154557777777777554404444400000000000000000000000000000000000000000
55666666555665555555566666666655444444444444554444444445511111155577777777777755440444040000000000000000000000000000000000000000
56666666656666655555666666666655444444444444444444444444511111155777777777777775444040440000000000000000000000000000000000000000
56666666656666655556666666666665444444444444444444444444511111655777777777777775444404440000000000000000000000000000000000000000
56666666656666655566666666666666444444445444444444554444511111155777777777777775444440440000000000000000000000000000000000000000
56666666656565655566666666666666444444444445544444544444511111155777777777777775444444040000000000000000000000000000000000000000
56665656555656555666666666666666444444444444444444444444511111155777777777777775444444400000000000000000000000000000000000000000
56666565656565655666666666666666000000000000000000000000000000004455554466666666000000000000000000000000000000000000000000000000
55565656555555555666666666666665000000000000000000000000000000004557755467777776000000000000000000000000000000000000000000000000
55555565555665555566666666666565000000000000000000000000000000005577775567777776000000000000000000000000000000000000000000000000
55565555566666655566666666665655000000000000000000000000000000005777777569999996000000000000000000000000000000000000000000000000
55665555665656655666666565656565000000000000000000000000000000005777777567977976000000000000000000000000000000000000000000000000
55656555666565655566665656565655000000000000000000000000000000005777777567999976000000000000000000000000000000000000000000000000
55565655565656555666656565656565000000000000000000000000000000005777777567777776000000000000000000000000000000000000000000000000
55555555555555555666565656565655000000000000000000000000000000005777777566666666000000000000000000000000000000000000000000000000
05556555666665550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00666666666666550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06666666666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05666666666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06666666666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00666665566666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05555665666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00666556666666650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06666665666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05666666566666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06666666666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05565666666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06656666656566660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05666666665666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06566606666066550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005050505055550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
4444444444444444444444444444444400404140414041404140414041404140410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4400000000000000000000000000004400505150515051505150515051505150510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4400006061606160616061606100004400404144444444444460616061444440410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4400007071707170717071707100004400505144444444444470717071444450510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44000060614a4a4a4a4a4a606100004400404144464444444460616061444640410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44000070714a4a4a4a4a4a707100004400505144444444464470717071444450510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44000060614a4a4a4a4a4a606100004400404144454444444444444444444440410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44000070714a4a4a4a4a4a707100004400505146444444464445444444444450510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44000060614a4a4a4a4a4a606100004400404144444544444444444544454440410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44000070714a4a4a4a4a4a707100004400505144444444444444444444444450510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4400006061606160616061606100004400404144444544444544444644444540410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4400007071707170717071707100004400505144444444444444444444444450510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4400000000000000000000000000004400404144444644444444464444454440410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4400000000000000000000000000004400505144464444444444444445444450510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4400000000000000000000000000004400404140414041404140414041404140410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4444444444444444444444444444444400505150515051505150515051505150510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000c0000120201102011020120201302015020180201b0201e0201b020110201102012020130201402015020170201b0201f020230200f0201002011020130201502017020190201d0201102015020170201a020
