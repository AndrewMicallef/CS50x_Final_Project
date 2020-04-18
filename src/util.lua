
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
