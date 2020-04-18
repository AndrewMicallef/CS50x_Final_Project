POPULATION = 450
-- Transmission is calculated on a 1-100 diceroll.
-- This translates to 3% probability of transmission
TRANSMISSION_PROBABILITY = 6
INFECTED = 3
WORLD_SIZE = 250

STATUS_COLOR = {
    ['healthy'] = {0, .65, 0, 1},    -- green
    ['infected'] = {1, .8, 0, 1},  -- orange
    ['recovered'] = {0, .8, 1, 1}, --light blue
    ['dead'] = {0.7, 0.7, 0.7, 1}, -- 70% grey
}
