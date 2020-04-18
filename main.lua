--[[
Contagin style game
]]

require 'src/Dependencies'

-- keep track of our people, note g to indicate global
gPeople = {}

POPULATION = 450
-- Transmission is calculated on a 1-100 diceroll.
-- This translates to 3% probability of transmission
TRANSMISSION_PROBABILITY = 6
INFECTED = 3
WORLD_SIZE = 250

function love.load()

    -- seed the RNG
    math.randomseed(os.time())

    -- initialise some people
    for i = 1, POPULATION do
        gPeople[i] = Person(i)
    end

    -- make some sick
    for i = 1, INFECTED do
        gPeople[i].gesundheit = 'infected'
    end

end

function love.update(dt)
    for i, person in ipairs(gPeople) do
        person:update(dt)
    end

end

function love.draw()

    love.graphics.push()
    local w, h, flags = love.window.getMode()
    local scale = math.min(w, h)
    -- work in units of 100
    love.graphics.scale(scale / WORLD_SIZE)
    love.graphics.setColor(.2,.2,.2,1)
    love.graphics.rectangle('fill', 1, 1, WORLD_SIZE - 2, WORLD_SIZE - 2)

    for i, person in ipairs(gPeople) do
        person:draw()
    end

    love.graphics.pop()
    drawFPS()
end

function drawFPS()
    local w, h, flags = love.window.getMode()
    love.graphics.setColor(1,1,0,1)
    love.graphics.print(love.timer.getFPS() .. ' fps', w - 60, 10)
end
