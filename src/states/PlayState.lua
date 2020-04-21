--[[
    Play State Class
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()

    player = Player()
    player:init(5, 5)

end

function PlayState:update(dt)
    player:update(dt)
end

function PlayState:render()

    -- draw world --------------------------------------------------------------

    local w, h, flags = love.window.getMode()
    local scale = math.min(w, h)
    ----[[
    love.graphics.push()

    -- work in units of 100
    --love.graphics.translate(w/2, h/2)
    love.graphics.scale(h/WORLD_SIZE)

    -- draw a grid to represent the world
    for u=0, WORLD_SIZE, 2.5 do
        for v=0, WORLD_SIZE, 2.5 do
            if ((u+v) % 5) == 0 then
                love.graphics.setColor(cPALETTE['c2'])
            else
                love.graphics.setColor(cPALETTE['c1'])
            end
            love.graphics.rectangle('fill', u, v, 2.5, 2.5,.2)
            end
    end
    --

    -- draw player -------------------------------------------------------------
    player:draw()
    love.graphics.pop()
    --]]

end
