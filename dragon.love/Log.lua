Log = Class{}

local LOG_IMAGE = love.graphics.newImage('log.png')

LOG_SCROLL = 60

LOG_HEIGHT = 219
LOG_WIDTH = 35

function Log:init(orientation, y)
    self.x = VIRTUAL_WIDTH

    self.y = y

    self.width = LOG_IMAGE:getWidth()
    self.height = LOG_HEIGHT

    self.orientation = orientation
end

function Log:update(dt)
    --self.x = self.x + LOG_SCROLL * dt
end

function Log:render()
    love.graphics.draw(LOG_IMAGE, self.x, 
    (self.orientation == 'top' and self.y + LOG_HEIGHT or self.y),
    0,
    1,
    self.orientation == 'top' and -1 or 1)
end