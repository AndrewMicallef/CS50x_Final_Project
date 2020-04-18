--[[
Contagin style game
]]

require 'src/Dependencies'

-- keep track of our people
gPeople = {}

POPULATION = 100

function love.load()

    math.randomseed(os.time())
    -- initialise some people
    for i = 1, POPULATION do
        gPeople[i] = Person()
    end
    gPeople[1].gesundheit = 'infected'

end

function love.update(dt)
    for i, person in ipairs(gPeople) do
        person:update(dt)
    end

end

function love.draw()

    local w, h, flags = love.window.getMode()
    local scale = math.min(w, h)
    -- work in units of 100
    love.graphics.scale(scale / 100)
    love.graphics.setColor(.2,.2,.2,1)
    love.graphics.rectangle('fill', 1, 1, 98, 98)

    for i, person in ipairs(gPeople) do
        person:draw()
    end
end
