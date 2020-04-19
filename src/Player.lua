Player = Class{__includes = Person}

Player.size = {w = 1.8, h = .5}

function Player:update(dt)

    self.Behaviours_switch[self.state](dt)

end

function Player:draw()

    -- PLAYER DRAW ROUTINE
    -- save current axis coordinates
    love.graphics.push()
    -- translate the axis to be centered on current position

    love.graphics.translate(self.pos.x, self.pos.y)
    -- rotate to face direction of travel
    love.graphics.rotate(self.facing)

    love.graphics.setColor(1,0,1,1)
    love.graphics.rectangle('line', -self.size.w/2, -self.size.h/2,
                                    self.size.w, self.size.h)

    --draw the body as a rectangle
    love.graphics.setColor(1,1,1,1)
    love.graphics.setLineWidth(.1)

    -- shoulders
    love.graphics.setColor(252/255, 255/255,53/255,255/255)
    love.graphics.rectangle('fill', -self.size.w/2, -self.size.h/2, self.size.w, self.size.h, self.size.h/2)

    -- head
    love.graphics.setColor(252/255,190/255,136/255,255/255)
    love.graphics.circle('fill', 0, self.size.h*.25, self.size.h*.8)

    love.graphics.setColor(.1,.2,.3,.5)
    love.graphics.scale(1, .8)
    love.graphics.translate(0, -.2)
    love.graphics.circle('fill', 0, self.size.h*.25, self.size.h*.8)
    -- return the axis to previous state
    love.graphics.pop()
    --
end

--------------------------------------------------------------------------------
-- BEHAVIOUR STATES

keymap_walk = {
    ['w'] = vector.new(0, -1),
    ['s'] = vector.new(0, 1),
    ['a'] = vector.new(-1, 0),
    ['d'] = vector.new(1, 0),
}

function Player:idle(dt)
    local direction
    local dv = vector.zero

    for key, direction in pairs(keymap_walk) do
        if love.keyboard.wasPressed[k] then
            dv = dv + direction
        end
    end
    if dv:len() then
        self:walk(dv, dt)
    end
end

function Player:walking(dt)
    local direction
    local dv = vector.zero

    for key, direction in pairs(keymap_walk) do
        if love.keyboard.isDown(key) then
            dv = dv + direction
        end
    end

    if dv:len() then
        self:walk(dv, dt)
    else
        self.state = 'idle'
    end

end
