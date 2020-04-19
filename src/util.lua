
-- AABB style collision between two objects.
--
-- Expects both objects to have a getBbox function which returns the x, y, w, h
-- of the object. Based of of Colton Ogden's AABB collision in fiftybird.
--
-- returns true on collision or false if no collision
function collision(object0, object1)

    local x0, y0, w0, h0 = object0:getBbox()
    local x1, y1, w1, h1 = object1:getBbox()

    if (x0 + w0) >= x1 and x0 <= x1 + w1 then
        if (y0 + h0) >= y1 and y0 <= y1 + h1 then
            return true
        end
    end
    return false
end


-- These three functions: isInsideSector, areClockwise, and isWithinRadius
-- constitue an algorithim for checking if a point is within a cirlce segment
-- the algorithim comes from https://stackoverflow.com/a/13675772, and has been
-- converted from javascript.

function isInsideSector(point, center, sectorStart, sectorEnd, radiusSquared)
    -- point, center, sectorStart, and sectorEnd are assumed to be vectors
    -- they need to have a .x and .y numerical attribute for this to work
    local relPoint = point - center

    return not areClockwise(sectorStart, relPoint)
           and areClockwise(sectorEnd, relPoint)
           and isWithinRadius(relPoint, radiusSquared)
end

function areClockwise(v1, v2)
    return -v1.x*v2.y + v1.y*v2.x > 0
end

function isWithinRadius(v, radiusSquared)
    return v.x*v.x + v.y*v.y <= radiusSquared
end

---
