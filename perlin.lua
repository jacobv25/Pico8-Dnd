points = {}
smoothed = {}
-- PERLIN NOISE
function random_points()
    local points = {}
    for x=1,proc_gen_map_width do
        points[x] = {}
        for y=1,proc_gen_map_height do
            points[x][y] = rnd(1) > 0.5 and 1 or 0
        end
    end
    return points
end

function smooth_points(points)
    local smooth = {}
    for x=1,proc_gen_map_width do
        smooth[x] = {}
        for y=1,proc_gen_map_height do
            local sum = points[x][y]
            local count = 1

            for dx=-1,1 do
                for dy=-1,1 do
                    local nx, ny = x+dx, y+dy
                    if points[nx] and points[nx][ny] then
                        sum = sum + points[nx][ny]
                        count = count + 1
                    end
                end
            end
            smooth[x][y] = sum / count
        end
    end
    return smooth
end

function to_heightmap(points)
    local heightmap = {}
    for x=1,proc_gen_map_width do
        heightmap[x] = {}
        for y=1,proc_gen_map_height do
            heightmap[x][y] = flr(points[x][y] * 6) + 1
        end
    end
    return heightmap
end