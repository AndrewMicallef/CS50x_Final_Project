Person = Class{}

local STATUS_COLOR = {
    ['healthy'] = {0, .65, 0, 1},    -- green
    ['infected'] = {1, .8, 0, 1},  -- orange
    ['recovered'] = {0, .8, 1, 1}, --light blue
    ['dead'] = {0.7, 0.7, 0.7, 1}, -- 70% grey
}

local WALK_SPEED = 20

function Person:init()

    self.pos = vector(math.random(4, 96), math.random(4, 96))

    self.vel = vector.fromPolar(math.random(0, 2), WALK_SPEED)

    -- can be one of: healthy, infected, recovered, dead
    self.gesundheit = 'healthy'
    self.state = 'walking'

    self.behaviours = {

        ['idle'] = function(dt) self:idle(dt) end,
        ['walking'] = function(dt) self:walking(dt) end,
        -- ... ....
        -- etc
    }
end

function Person:update(dt)
    -- for the time being let's get people walking about randomly
    self.behaviours[self.state](dt)

end

function Person:draw()
    love.graphics.setColor(STATUS_COLOR[self.gesundheit])
    love.graphics.circle('fill', self.pos.x, self.pos.y, 1)
end


--------------------------------------------------------------------------------
function Person:idle(dt)

end

function Person:walking(dt)
    self.pos = self.pos + self.vel * dt

    if (self.pos.x > 99)  or (self.pos.x < 1) then
        self.vel.x = -self.vel.x
    end
    if (self.pos.y > 99)  or (self.pos.y < 1) then
        self.vel.y = -self.vel.y
    end
end
