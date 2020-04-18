Person = Class{}

local STATUS_COLOR = {
    ['healthy'] = {0, .65, 0, 1},    -- green
    ['infected'] = {1, .8, 0, 1},  -- orange
    ['recovered'] = {0, .8, 1, 1}, --light blue
    ['dead'] = {0.7, 0.7, 0.7, 1}, -- 70% grey
}

local WALK_SPEED = 20

function Person:init(index)
    self.index = index
    self.radius = 2
    self.pos = vector(math.random(10, 60), math.random(10, 60))
    self.vel = vector.fromPolar(math.random()*2, WALK_SPEED)

    self.bbox = {self.pos.x, self.pos.y, 2*self.radius, 2*self.radius}

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
    self.bbox = {self.pos.x, self.pos.y, 2*self.radius, 2*self.radius}
end

function Person:draw()
    local r = self.radius
    love.graphics.setColor(STATUS_COLOR[self.gesundheit])
    love.graphics.circle('fill', self.pos.x, self.pos.y, r)
    love.graphics.setColor(1,1,1,1)
    love.graphics.setLineWidth(.2)
    love.graphics.rectangle('line', self.pos.x - r, self.pos.y - r, 2*r, 2*r)
end


--------------------------------------------------------------------------------
function Person:idle(dt)

end

function Person:walking(dt)

    -- check collision
    for i, person in pairs(gPeople) do
        if i ~= self.index then -- ignore self collisions
            if collision(self, person) then

                while vector().dist(self.pos, person.pos) < (self.radius + person.radius)*1.05 do
                    -- nudge this person a tad
                    self.pos = self.pos - self.vel * dt
                end

                -- TODO clean this up... remember each body should exert a force on the other

                local vnet = self.vel - person.vel

                self.vel = (vnet):perpendicular():trimmed(WALK_SPEED)
                person.vel = (person.vel + vnet):trimmed(WALK_SPEED)

                if person.gesundheit == 'infected' then
                    self.gesundheit = 'infected'
                end
                
            end
        end
    end

    self.pos = self.pos + self.vel * dt

    if (self.pos.x + self.radius > 99) or (self.pos.x - self.radius < 1) then
        self.pos.x = self.pos.x - self.vel.x * dt
        self.vel.x = -self.vel.x
    end
    if (self.pos.y + self.radius> 99) or (self.pos.y - self.radius< 1) then
        self.pos.y = self.pos.y - self.vel.y * dt
        self.vel.y = -self.vel.y
    end


end


--[[
function dist(a, b)
	assert(isvector(a) and isvector(b), "dist: wrong argument types (<vector> expected)")
	local dx = a.x - b.x
	local dy = a.y - b.y
	return math.sqrt(dx * dx + dy * dy)
end
-- ]]
--------------------------------------------------------------------------------
