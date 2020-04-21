--[[
    TitleScreenState Class

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The TitleScreenState is the starting screen of the game, shown on startup. It should
    display "Press Enter" and also our highest score.
]]

TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed['enter'] or love.keyboard.wasPressed['return'] then
        gStateMachine:change('play')
    end
end

function TitleScreenState:render()
    love.graphics.setColor(cPALETTE['c0'])
    love.graphics.setFont(gFONTS['titleFont'])
    love.graphics.printf('WELCOME', 0, 250, 800, 'center')

    love.graphics.setColor(cPALETTE['c2'])
    love.graphics.setFont(gFONTS['mediumFont'])
    love.graphics.printf('Press Enter', 0, 350, 800, 'center')
end
