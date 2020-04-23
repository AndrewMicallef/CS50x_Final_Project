Item = Class{}

function Item:init(x,y)
    self.posx = x
    self.posy = y
end

function Item:render()

    love.graphics.setColor(cPALETTE['c3'])
    love.graphics.circle('line', self.posx, self.posy, 6)
end

function Item:update(dt)

end

--[[

tp rolls have:
 - location
 -
--]]
