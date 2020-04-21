Character = Class{}

function Character:init(world, x, y, w, h)

    -- initialise the state
    self.state = 'idle'

    -- position and dimensions of the character
    self.x = x
    self.y = y
    self.w = w
    self.h = h

    -- variables to keep track of velocity
    self.dx, self.dy = 0, 0

    -- attaches a new collider to the Character
    self.collider = world:newRectangleCollider(self.x, self.y, self.w, self.h)
    self.collider:setCollisionClass('sticky')
    self.collider:setObject(self.collider)

    -- make an internal reference to world
    self.world = world

    --[[
         Behavior map we can call based on Character state.
         This map includes all states the Character can be in. Each state
         calls a function that lays out the transitions to the next states
       ]]
    self.behaviors = {
        -- Standing on a platform doing nothing
        ['idle'] = function(dt) self:idle(dt) end,
    }

end

function Character:draw()

    -- Setup coordinates
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.collider:getAngle())

    -- draw head and body
    love.graphics.setLineWidth(1)
    love.graphics.setColor(.8, 0, 0, 1)
    love.graphics.rectangle('fill', 0-self.w/2, 0-self.h/2, self.w, self.h)
    love.graphics.circle('fill', 0, 0-self.h, 8)
    love.graphics.pop()
end

function Character:update(dt)
    self.x, self.y = self.collider:getPosition()

    -- MAKE A CIRCULAR UNIVERSE
    if self.collider:getX() > love.graphics.getWidth() then
        self.collider:setX(0)
    elseif self.collider:getX() < 0 then
        self.collider:setX(love.graphics.getWidth())
    end
end


--------------------------------------------------------------------------------
--                           BEHAVIOUR STATES                                 --
--------------------------------------------------------------------------------

function Character:idle(dt)
end

--------------------------------------------------------------------------------
--                             CHARACTER ACTIONS                                 --
--------------------------------------------------------------------------------
