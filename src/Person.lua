Person = Class{}

local infection_timer = 0
local recovery_timer = 0

local WALK_SPEED = 20

function Person:init(index)
    self.index = index
    self.radius = 2
    self.debug= 0

    local buffer = self.radius * 2
    self.pos = vector(math.random(buffer, WORLD_SIZE - buffer),
                      math.random(buffer, WORLD_SIZE - buffer))
    self.vel = vector.fromPolar(math.random()*2, WALK_SPEED)

    -- health realted properties
    self.day = 0
    self.transmission_rate = TRANSMISSION_PROBABILITY

    self.shouting = true

    -- Gesundheit:
    -- German for health, in this case tracks the health state of our person
    -- can be one of: healthy, infected, recovered, dead
    self.gesundheit = 'healthy'
    self.state = 'idle'

    -- state machine for health status
    self.health = {
        ['healthy'] = function(dt) return self:healthy(dt) end,
        ['infected'] = function(dt) return self:infected(dt) end,
        ['recovered'] = function(dt) return self:recovered(dt) end,
        ['dead'] = function(dt) return self:dead(dt) end,
    }

    -- state machine for behaviours
    self.behaviours = {

        ['idle'] = function(dt) return self:idle(dt) end,
        ['walking'] = function(dt) return self:walking(dt) end,
        -- ... ....
        -- etc
    }
end

function Person:update(dt)
    -- for the time being let's get people walking about randomly
    self.behaviours[self.state](dt)
    self.health[self.gesundheit](dt)

    if (self.pos.x + self.radius > WORLD_SIZE - 1) then
        self.pos.x = WORLD_SIZE - self.radius
    end
    if (self.pos.x - self.radius < 1) then
        self.pos.x = 1 + self.radius
    end
    if (self.pos.y + self.radius > WORLD_SIZE - 1) then
        self.pos.y = WORLD_SIZE - self.radius
    end
    if (self.pos.y - self.radius < 1) then
        self.pos.y = 1 + self.radius
    end
end

function Person:draw()
    local r = self.radius
    local theta = self.vel:toPolar().x
    theta = theta % 2
    self.debug = theta
    love.graphics.push()
    -- draw relative to Persons' axis
    love.graphics.translate(self.pos.x, self.pos.y)
    --love.graphics.rotate(theta)

    love.graphics.setColor(STATUS_COLOR[self.gesundheit])
    love.graphics.circle('fill', 0, 0, r)

    if self.gesundheit == 'infected' then
        love.graphics.setColor(1,1,1, 1)
        love.graphics.setLineWidth(.2)
        mv = self.vel
        love.graphics.line(mv.x, mv.y, 0, 0)
        --love.graphics.arc('line', 0, 0, r*3, theta-.5, theta+.5)
    end
    love.graphics.pop()
    --end
    -- bounding box for debug
    -- love.graphics.rectangle('line', self.pos.x - r, self.pos.y - r, 2*r, 2*r)
end

--------------------------------------------------------------------------------
-- BEHAVIOUR STATES
--------------------------------------------------------------------------------

function Person:idle(dt)
end

function Person:walking(dt)
    self.vel = self.vel:trimmed(WALK_SPEED)

    -- check collision
    -- TODO SIMPLIYFY COLLISION DETECTION
    for i, person in pairs(gPeople) do
        if i ~= self.index then -- ignore self collisions
            if collision(self, person) then

                -- nudge this person a tad if they are overlapping their neighbour
                while vector().dist(self.pos, person.pos) < (self.radius + person.radius)*1.05 do
                    self.pos = self.pos - self.vel * dt
                end

                -- TODO clean this up... remember each body should exert a force on the other
                local vnet = self.vel - person.vel

                self.vel = (vnet):perpendicular():trimmed(WALK_SPEED)
                person.vel = (person.vel + vnet):trimmed(WALK_SPEED)

                if person.gesundheit == 'infected' and math.random(100) < person.transmission_rate then
                    if self.gesundheit == 'healthy' then -- only the healthy can be infected
                         self.gesundheit = 'infected'
                     end
                end
            end
        end
    end

    self.pos = self.pos + self.vel * dt

    if (self.pos.x + self.radius > WORLD_SIZE - 1) or (self.pos.x - self.radius < 1) then
        self.pos.x = self.pos.x - self.vel.x * 1.5*dt
        self.vel.x = -self.vel.x
    end
    if (self.pos.y + self.radius> WORLD_SIZE - 1) or (self.pos.y - self.radius< 1) then
        self.pos.y = self.pos.y - self.vel.y * 1.5*dt
        self.vel.y = -self.vel.y
    end
end

--------------------------------------------------------------------------------
-- HEALTH STATES
--------------------------------------------------------------------------------

function Person:healthy(dt)
end

function Person:infected(dt)
    self:shout()
    --[[
    local prevday = self.day
    -- works out to be about 1 day per second or so
    infection_timer = infection_timer + dt/10
    self.day = math.floor(infection_timer + dt/10)
    --math.floor(infection_timer)

    --self.debug = self.transmission_rate
    if prevday ~= self.day then

        self.transmission_rate = math.min(100, self.transmission_rate * 2)

        if self.day > 15 and math.random(100) < 2 then
            self.gesundheit = 'dead'
        end

        if self.day > 30 and math.random(100) < 5 then
            self.gesundheit = 'recovered'
        end
    end
    -- ]]
end

function Person:recovered(dt)
    --[[
    local prevday = self.day
    infection_timer = infection_timer + dt/10
    self.day = math.floor(infection_timer + dt/10)

    if prevday == self.day then
        return
    end

    if self.day > 7 and math.random(100) < 2 then
        self.gesundheit = 'healthy'
    end
    -- ]]
end

function Person:dead(dt)
    -- should no longer count for collision detection....
    self.state = 'idle'
end

--------------------------------------------------------------------------------
-- utilities

function Person:getBbox()
    return self.pos.x, self.pos.y, 2*self.radius, 2*self.radius
end

-- returns the direction someone is facing
function Person:getFacing()
    -- TODO
end

-- sets the direction someone is facing, including velocity if they are walking
function Person:setFacing()
    -- TODO
end

--------------------------------------------------------------------------------
-- Player Actions
--------------------------------------------------------------------------------

function Person:shout()
    -- cast a circular segemt out in the direction the person is facing
    -- creates a temporary field, any person within the field gets pushed away
    -- from the segment.
    -- Also draw some random ASCII characters from the set *&%$#!*
    local facing = self.vel:normalized():toPolar().x
    local shout_angle, shout_strength = 0.5, 70

    -- https://stackoverflow.com/a/13675772
    for i, person in pairs(gPeople) do
        if i == self.i then goto continue end

        local checkperson = isInsideSector(person.pos, self.pos,
                                           self.vel:rotated(-shout_angle),
                                           self.vel:rotated(shout_angle),
                                           math.pow(shout_strength,2))

        if checkperson then
            person.gesundheit = 'recovered'
        end
        -- draw a line
        ::continue::
    end
end
