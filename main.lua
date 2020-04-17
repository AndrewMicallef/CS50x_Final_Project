--[[
Contagin style game
]]

-- https://github.com/vrld/hump
Class = require 'lib/class'
vector  = require 'lib/vector'

require 'Person'

-- keep track of our people
people = {}

POPULATION = 30

function love.load()

    math.randomseed(os.time())
    -- initialise some people
    for i = 1, POPULATION do
        people[i] = Person()
    end

end

function love.update(dt)
    for i, person in ipairs(people) do
        person:update(dt)
    end

end

function love.draw()

    local w, h, flags = love.window.getMode()
    -- work in units of 100
    love.graphics.scale(w / 100, h / 100)
    love.graphics.setColor(.2,.2,.2,1)
    love.graphics.rectangle('fill', 1, 1, 98, 98)

    for i, person in ipairs(people) do
        person:draw()
    end
end
