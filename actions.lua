actions = {
    move_player = function (player, x, y)
        player.x = x
        player.y = y
    end,
    lerp_player = function (player, x, y, t)
        player.x = lerp(player.x, x, t)
        player.y = lerp(player.y, y, t)
    end,
}

-- lerp function
function lerp(a, b, t)
  return a + (b - a) * t
end