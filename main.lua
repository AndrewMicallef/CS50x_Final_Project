--[[
Contagin style game
]]

require 'src/Dependencies'

-- keep track of our people, note g to indicate global
gPeople = {}


function love.load()

    -- seed the RNG
    math.randomseed(os.time())
    player = Player()
    player:init(5, 5)

end

function love.update(dt)
    player:update(dt)

    love.keyboard
end

function love.draw()

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
                love.graphics.setColor(.6,.6,.6,1)
            else
                love.graphics.setColor(.8,.8,.8,1)
            end
            love.graphics.rectangle('fill', u, v, 2.5, 2.5,.2)
            end
    end
    --

    player:draw()
    love.graphics.pop()
    --]]

    drawFPS()
end

function drawFPS()
    local w, h, flags = love.window.getMode()
    love.graphics.setColor(1,1,0,1)
    love.graphics.print(love.timer.getFPS() .. ' fps', w - 60, 10)
end
