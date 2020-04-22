POPULATION = 0
-- Transmission is calculated on a 1-100 diceroll.
-- This translates to 3% probability of transmission
TRANSMISSION_PROBABILITY = 6
INFECTED = 0
WORLD_SIZE = 20

STATUS_COLOR = {
    ['healthy'] = {0, .65, 0, 1},    -- green
    ['infected'] = {1, .8, 0, 1},  -- orange
    ['recovered'] = {0, .8, 1, 1}, --light blue
    ['dead'] = {0.7, 0.7, 0.7, 1}, -- 70% grey
}



gFONTS = {
    ['titleFont'] = love.graphics.newFont('assets/fonts/comicbd.ttf', 50),
    ['mediumFont'] = love.graphics.newFont('assets/fonts/ka1.ttf', 20),
    ['smallDebug'] = love.graphics.newFont('assets/fonts/comicbd.ttf', 15),

}

-- https://coolors.co/d79abc-baabda-9fdfcd-dcffcc-ffffff
cPALETTE = {
    ['c0'] = hex("#d79abc"),
    ['c1'] = hex("#baabda"),
    ['c2'] = hex('#9fdfcd'),
    ['c3'] = hex('#dcffcc'),
    ['c4'] = hex('#ffffff')
}
