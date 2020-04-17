--[[
Contagin style game
]]

Class = require 'lib/class'
require 'Person'

-- keep track of our people
people = {}

POPULATION = 30

function love.load()

    -- initialise some people
    for i = 1, POPULATION do
        people[i] = Person()
    end

end

function love.update(dt)
end

function love.draw()

    local w, h, flags = love.window.getMode()
    -- work in units of 100
    love.graphics.scale(w / 100, h / 100)

    for i, person in ipairs(people) do
        person:draw()
    end
end
