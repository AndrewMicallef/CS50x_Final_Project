Person = Class{}

local STATUS_COLOR = {
    ['healthy'] = {0, 1, 0, 1},    -- green
    ['infected'] = {1, .8, 0, 1},  -- orange
    ['recovered'] = {0, .8, 1, 1}, --light blue
    ['dead'] = {0.7, 0.7, 0.7, 1}, -- 70% grey
}

function Person:init()

    self.x = math.random(0, 100)
    self.y = math.random(0, 100)
    -- can be one of: healthy, infected, recovered, dead
    self.gesundheit = 'healthy'

    self.behaviours = {

        ['idle'] = function(dt) self:idle(dt) end,
        ['walking'] = function(dt) self:walking(dt) end,
        -- ... ....
        -- etc
    }
end

function Person:update(dt)

end

function Person:draw()
    love.graphics.setColor(STATUS_COLOR[self.gesundheit])
    love.graphics.circle('fill', self.x, self.y, .5)
end
