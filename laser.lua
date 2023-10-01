function laserbeam(lx1, lx2, ly1, ly2, steps, maxwidth, mwage)
    -- Helper function to create the pattern based on the index.
    local function createPattern(index)
        if index % 2 == 0 then
            return {
                0,
                0B10100100100, 
                0B1111111111111111, 
                0B110000000110,
                0
            }
        else
            return {
                0,
                0B010100100010,
                0B1111111111111111,
                0B101100000001,
                0,
            }
        end
    end

    -- Helper function to reduce duplication.
    local function addPart(w, wait, pattern)
        add(laserE.parts, {
            x1 = lx1,
            x2 = lx2,
            y1 = ly1,
            y2 = ly2,
            w = w,
            wait = wait,
            maxage = 4,
            draw = laser,
            pat = pattern
        })
    end

    for i = 1, steps do
        addPart(maxwidth * i / steps, (i - 1) * 4, createPattern(0))
    end

    for j = 1, mwage do
        addPart(maxwidth, (steps*4) + (j-1) * 4, createPattern(j))
    end
end


function dolaserbeam_part(p)
    if p.wait then
        -- wait cooldown
        p.wait -= 1
        if p.wait <= 0 then
            p.wait = nil
        end
    else
        p.age = p.age or 0

        if p.age == 0 then
            p.ox = p.x
            p.oy = p.y
        end
        p.age += 1

        if p.age >= p.maxage then
            del(laserE.parts, p)
        end
    end
end

function laser(p)
    -- myw = flr(p.w)
    local myw = flr(p.w)

    local thk = {
        myw,
        myw * 0.90,
        myw * 0.75,
        myw * 0.65,
        myw * 0.5
    }
    -- local pat = {
    --     0, --orange
    --     0B10100100100, -- some transition
    --     0B1111111111111111, -- yellow
    --     0B110000000110, -- some transition
    --     0 -- white
    -- }

    for i = 1, #thk do
        fillp(p.pat[i])
        if i <= 2 then
            col = 169
        else
            col = 167
        end
        rectfill(p.x1, p.y1 - thk[i], p.x2, p.y2 + thk[i], col)
    end
    fillp()
end
