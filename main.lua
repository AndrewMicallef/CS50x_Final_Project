--[[
Contagin style game
]]

require 'src/Dependencies'

-- keep track of our people, note g to indicate global
gPeople = {}

function love.load()

    -- seed the RNG
    math.randomseed(os.time())

    -- initialise some people
    for i = 1, POPULATION do
        gPeople[i] = Person(i)
    end

    -- make some sick
    for i = POPULATION - INFECTED, POPULATION do
        gPeople[i].gesundheit = 'infected'
    end

    display = Display()
    display:init()
end

function love.update(dt)
    for i, person in ipairs(gPeople) do
        person:update(dt)
    end

    display:update()

end

function love.draw()

    local w, h, flags = love.window.getMode()
    local scale = math.min(w, h)
    ----[[
    love.graphics.push()

    -- work in units of 100
    love.graphics.translate(0, h*.01)
    love.graphics.scale(scale / WORLD_SIZE * .95)
    love.graphics.setColor(.2,.2,.2,1)
    love.graphics.rectangle('fill', 1, 1, WORLD_SIZE - 2, WORLD_SIZE - 2)

    for i, person in ipairs(gPeople) do
        person:draw()
    end

    love.graphics.pop()

    love.graphics.print(gPeople[1].debug, 1, 1)
    --]]

    display:draw()
    drawFPS()
end

function drawFPS()
    local w, h, flags = love.window.getMode()
    love.graphics.setColor(1,1,0,1)
    love.graphics.print(love.timer.getFPS() .. ' fps', w - 60, 10)
end
