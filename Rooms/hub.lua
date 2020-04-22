Hub = Class{__includes = BaseState}

function Hub:init()

        self.world = wf.newWorld(0, 512, true)
        --self.world:setGravity(0, 512)
        ww, wh, f = love.window.getMode()
        sx, sy = ww / 150,  wh/100
        w, h = 10, 10

        positions = {{60, 70},
                     {100, 70},
                     {80, 30},
                     {90, 20},
                     {100, 10},
                     {50, 80},
                     {10, 40},
                     {30, 40}
                    }

        platforms = {}

        for i,v in ipairs(positions) do
            -- body...
            local px = math.floor(v[1] * sx)
            local py = math.floor(v[2]*sy)
            local pw = math.floor(w*sx)
            local ph = math.floor(h*sy)

            platforms[i] = self.world:newRectangleCollider(px, py, pw, ph)
            platforms[i]:setType('static')
            platforms[i]:setObject(platforms[i])
            platforms[i]:setFriction(.4)

        end
        ground = self.world:newRectangleCollider(math.floor(0 * sx),
                                    math.floor(90*sy),
                                    math.floor(150*sx),
                                    math.floor(4*sy)
                                )

        ground:setType('static')
        ground:setObject(ground)
        ground:setFriction(.4)

        -- create a player object in this world at x,y with dimensions w,h
        -- Player:init(world, x, y, w, h)
        player = Player(self.world, 150, 50, 10, 30)
        NPC = Character(self.world, 900, 200, 30, 50)
end

function Hub:update(dt)
    self.world:update(dt)
    player:update(dt)
    NPC:update(dt)
end

function Hub:render()

    cam:lookAt(player.x, player.y)

    love.graphics.setColor(cPALETTE['c0'])
    love.graphics.setFont(gFONTS['titleFont'])
    love.graphics.printf('THIS IS ROOM0', 0, 250, 800, 'center')


    self.world:draw()

    player:draw()
    NPC:draw()
end

--[[
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end
]]
