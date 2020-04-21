--[[
Contagin style game
]]

require 'src/Dependencies'

-- keep track of our people, note g to indicate global
gPeople = {}



function love.load()

    -- seed the RNG
    math.randomseed(os.time())

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
    }

    -- this now handles the initilialisation of elemnents
    gStateMachine:change('title')

    love.keyboard.wasPressed = {}
    love.keyboard.wasReleased = {}
end

function love.update(dt)

    -- single upate call which updates depending on the state we are in
    gStateMachine:update(dt)

    love.keyboard.wasPressed = {}
    love.keyboard.wasReleased = {}
end

function love.draw()

    -- now, we just update the state machine, which defers to the right state
    gStateMachine:render(dt)
    drawFPS()
end

function drawFPS()
    local w, h, flags = love.window.getMode()
    love.graphics.setColor(1,1,0,1)
    love.graphics.print(love.timer.getFPS() .. ' fps', w - 60, 10)
end


--------------------------------------------------------------------------------
-- KEYBOARD

function love.keypressed(key)
    love.keyboard.wasPressed[key] = true
end

function love.keyreleased(key)
    love.keyboard.wasReleased[key] = true
end
