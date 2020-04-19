Player = Class{__includes = Person}

function Player:init(x,y)

    self.pos = vector.new(x,y)
    self.vel = vector.new(0,0)

    self.size = {w = 1.8, h = .5}

    self.state = 'idle'
    self.gesundheit = 'healthy'

end

function Player:update(dt)


end

function Player:draw()

    -- PLAYER DRAW ROUTINE
    -- save current axis coordinates
    love.graphics.push()
    -- translate the axis to be centered on current position
    love.graphics.translate(self.pos.x, self.pos.y)

    --draw the body as a rectangle
    love.graphics.setColor(1,1,1,1)
    love.graphics.setLineWidth(.1)

    -- shoulders
    love.graphics.setColor(252/255, 255/255,53/255,255/255)
    love.graphics.rectangle('fill', 0, 0, self.size.w, self.size.h, self.size.h/2)
    -- head
    love.graphics.setColor(252/255,190/255,136/255,255/255)
    love.graphics.circle('fill', self.size.w/2, self.size.h*.45, self.size.h*.8)
    -- return the axis to previous state
    love.graphics.pop()
    --
end
