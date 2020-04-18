Display = Class{}

function Display:init()
    self.bars = {}

    for k, v in pairs(STATUS_COLOR) do
        self.bars[k] = 0
    end
end

function Display:update()

    for k, v in pairs(STATUS_COLOR) do
        self.bars[k] = 0
    end
    for i, person in ipairs(gPeople) do
        self.bars[person.gesundheit] = self.bars[person.gesundheit] + 1
    end

end

function Display:draw()

    local w, h, flags = love.window.getMode()
    love.graphics.push()
    love.graphics.translate(w*.8, 0)
    love.graphics.scale(w/5,h)

    love.graphics.setColor(.8,.8,.8,.5)

    love.graphics.rectangle('fill', 0, 0, .75, 1, .03, .01)

    aggy = 0
    for k, v in pairs(STATUS_COLOR) do
        local h = self.bars[k] / POPULATION
        love.graphics.setColor(v)
        love.graphics.rectangle('fill', 0, aggy, .7, h)
        aggy = aggy + h

    end
    love.graphics.pop()

    i = 0
    for k, v in pairs(STATUS_COLOR) do
        love.graphics.setColor(v)
        love.graphics.print(k, 30 + i * 100, h - 20)
        i = i + 1
    end

end
