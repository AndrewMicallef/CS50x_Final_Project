--[[
    Play State Class
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()

    -- initialize state machine with all state-returning functions
    wStateMachine = StateMachine {
        ['hub'] = function() return Hub() end,
    }

    -- this now handles the initilialisation of elemnents
    wStateMachine:change('hub')

end

function PlayState:update(dt)
    wStateMachine:update(dt)
end

function PlayState:render()
    wStateMachine:render()
end
