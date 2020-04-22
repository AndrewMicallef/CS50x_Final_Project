-- Note Paths are relative to main.lua

-- https://github.com/vrld/hump
Class = require 'lib/hump/class'
vector  = require 'lib/hump/vector'
camera = require 'lib/hump.camera'

-- https://github.com/adnzzzzZ/windfield
-- wrapper around box2d physics, combines all three elements into
-- single collider object
wf = require 'lib/windfield'

-- https://github.com/darkingreen/Colorized-for-Love
-- hexs to coverts rgba qutruples
require 'lib/colorized'

require 'src/CONSTANTS'

-- state machine abstraction ala Colton Ogden
require 'src/StateMachine'
require 'src/states/BaseState'
require 'src/states/TitleScreenState'
require 'src/states/PlayState'

-- Base Classes
require 'src/Class/Character'
require 'src/Class/Player'

-- Room States
require 'Rooms/Hub'

require 'src/util'
