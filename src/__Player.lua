Player = Class{}

function Player:init(world, x,y,w,h)

    -- initialise the state
    self.state = 'idle'

    -- position and dimensions of the player
    self.x = x
    self.y = y
    self.w = w
    self.h = h

    -- position of the players hand (gun)
    self.hx = 0
    self.hy = 0

    -- grapple hook and rope
    self.ghook = nil
    self.rope = nil
    self.ropelength = 250

    -- reference to anchored object and anchor points
    self.anchor = nil
    self.ax, self.ay = nil, nil

    -- variables to keep track of velocity
    self.dx, self.dy = 0, 0

    -- because double jumping is fun!
    self.jumpcount = 0

    -- attaches a new collider to the player
    self.collider = world:newRectangleCollider(self.x, self.y, self.w, self.h)
    self.collider:setCollisionClass('Player')
    self.collider:setLinearDamping(.1)

    -- make an internal reference to world
    self.world = world

    --[[
         Behavior map we can call based on player state.
         This map includes all states the player can be in. Each state
         calls a function that lays out the transitions to the next states
       ]]
    self.behaviors = {
        -- Standing on a platform doing nothing
        ['idle'] = function(dt) self:idle(dt) end,
        -- moving left or right along a platform
        ['running'] = function(dt) self:running(dt) end,
        -- swinging left or right along the rope
        ['swinging'] = function(dt) self:swinging(dt) end,
        -- launching oneself in a carefree manner from a platform
        ['jumping'] = function(dt) self:jumping(dt) end,
        -- anytime our character tips over
        ['falling'] = function(dt) self:falling(dt) end
    }

end

function Player:draw()

    -- Draw torso
    love.graphics.push()

    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.collider:getAngle())

    local hx, hy = love.graphics.inverseTransformPoint(self.hx, self.hy)

    -- draw head and body
    love.graphics.setColor(.75, .75, 0, 1)
    love.graphics.rectangle('fill', 0-self.w/2, 0-self.h/2, self.w, self.h)
    love.graphics.circle('fill', 0, 0-self.h, 8)
    love.graphics.circle('fill', hx - 2, hy - 2, 4)

    -- draw hand and arm
    love.graphics.setLineWidth(3)
    love.graphics.setColor(.5, .5, 0, 1)
    love.graphics.line(0, -self.h/5, hx - 2, hy - 2)


    -- Draw rope
    if self.rope then
        ax, ay = love.graphics.inverseTransformPoint(self.ax, self.ay)
        love.graphics.setColor(.9, .2, 0, 1)
        love.graphics.line(ax, ay, 0, 0)
    end
    --]]

    love.graphics.pop()
    love.graphics.setLineWidth(1)

end

function Player:update(dt)
    self.behaviors[self.state](dt)

    self.x, self.y = self.collider:getPosition()
    self.dx, self.dy = self.collider:getLinearVelocity()

    self.hx, self.hy = self:getAimVector(20)
    self.hx = self.hx + self.x
    self.hy = self.hy + self.y

    if self.rope then
        local x0, y0 = nil, nil
        x0, y0, self.ax, self.ay = self.rope:getAnchors()
    end

    -- GRAPPLE HOOK LOGIC
    if self.ghook and self.ghook:enter('sticky') then
        self.state = 'swinging'
        local collision_data = self.ghook:getEnterCollisionData('sticky')
        self.anchor = collision_data.collider:getObject()
        self.ax, self.ay = self.ghook:getPosition()

        -- set the rope length to some fraction of the current distance (Pythagoras)
        -- or 50 units, whichever is greater
        self.ropelength = math.max(50, math.sqrt(math.pow(self.ax - self.x, 2) + math.pow(self.ay - self.y, 2)) * .5)

        self.rope = world:addJoint('RopeJoint',
                                self.collider, self.anchor,
                                self.x, self.y,
                                self.ax, self.ay,
                                self.ropelength, true)
        self.ghook:destroy()
        self.ghook = nil
    end

    -- FIRE A SHOT
    if love.mouse.isDown(1) then
        -- fire a hook
        self:fire(20)
        self.state = 'idle'
    end

    -- MAKE A CIRCULAR UNIVERSE
    if self.collider:getX() > love.graphics.getWidth() then
        self.collider:setX(0)
    elseif self.collider:getX() < 0 then
        self.collider:setX(love.graphics.getWidth())
    end

end

function Player:getAimVector(r)
    r = r or 1
    cx, cy = love.mouse.getPosition()

    a = cx - self.x
    b = cy - self.y

    angle = math.atan2(b,a)

    rx = r * math.cos(angle)
    ry = r * math.sin(angle)

    return rx, ry
end


--------------------------------------------------------------------------------
--                           BEHAVIOUR STATES                                 --
--------------------------------------------------------------------------------

function Player:idle(dt)
    -- IDLE happens when we are on a platform and not moving
    self.jumpcount = 0

    -- MOVEMENT: right, left, jump
    if love.keyboard.isDown("d") then
        self.state = "running"
        self:run(1, 5)
    elseif love.keyboard.isDown("a") then
        self.state = "running"
        self:run(-1, 5)
    end

    if love.keyboard.wasPressed("space") then
        self:jump()
    end

    if self.dy > 0.01 then
        self.state = "falling"
    end

    -- check that we are still idle
    if self.state == 'idle' then
        self.jumpcount = 0
        -- todo
    end
end

function Player:running(dt)

    if love.keyboard.isDown("d") then
        self:run(1, 5)
    end
    if love.keyboard.isDown("a") then
        self:run(-1, 5)
    end


    self:jump()

    if math.abs(self.dx) < 0.1 and math.abs(self.dy) < 0.1 then
        self.state = "idle"
    end
end

function Player:swinging(dt)
    -- NOTE: this state implies the grapple hook is attached to something.

    -- swing left or right
    -- TODO apply a decreasing force based on current momentum and heading
    if love.keyboard.isDown("d") then
        self.collider:applyLinearImpulse(5,0)
    end
    if love.keyboard.isDown("a") then
        self.collider:applyLinearImpulse(-5,0)
    end
    -- detach with space bar
    if love.keyboard.isDown("space") then

        self:tryDestroyGrapple()
        self:jump()
    end

end

function Player:jumping(dt)

    -- TODO jump realtive to player heading
    self:jump()

    if love.keyboard.isDown("d") then
        self:run(1, 5)
    end
    if love.keyboard.isDown("a") then
        self:run(-1, 5)
    end

    if self.dy > 0 then
        self.state = 'falling'
    end
end

function Player:falling(dt)

    -- TODO jump realtive to player heading
    self:jump()

    if love.keyboard.isDown("d") then
        self:run(1, 5)
    end
    if love.keyboard.isDown("a") then
        self:run(-1, 5)
    end

    if self.collider:enter('sticky') then
        self.state = 'idle'
        -- if vnet > some threshold do damage to player or contact....
    end
end


--------------------------------------------------------------------------------
--                             PLAYER ACTIONS                                 --
--------------------------------------------------------------------------------

function Player:fire(force)
    -- offsets the launch to 20 units from player to avoid collision
    rx, ry = self:getAimVector(20)

    self:tryDestroyGrapple()
    self.ghook = self.world:newRectangleCollider(self.x + rx, self.y + ry, 2.5, 2.5)
    self.ghook:applyLinearImpulse(force*rx, force*ry)
    self.ghook:setBullet(true)

end

function Player:jump()
    if love.keyboard.wasPressed("space") and self.jumpcount < 2 then

        self.state = "jumping"
        self.jumpcount = self.jumpcount + 1
        self.collider:applyLinearImpulse(0, -200)

        return true
    end

    return false

end

function Player:run(heading, speed)
    -- TODO apply a decreasing force based on current momentum
    self.collider:applyLinearImpulse(speed * heading, 0)
end

function Player:tryDestroyGrapple()

    -- destroy the hook and rope
    if self.rope then
        self.rope:destroy()
        self.rope = nil
    end
    if self.ghook then
        self.ghook:destroy()
        self.ghook = nil
    end
    self.anchor = nil
end
