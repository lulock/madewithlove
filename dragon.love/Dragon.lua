Dragon = Class{}

local GRAVITY = 20

function Dragon:init()
    self.image = love.graphics.newImage('dragon.png')

    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y =  VIRTUAL_HEIGHT / 2 - (self.height /2)

    self.dy = 0
end

function Dragon:render()
    love.graphics.draw(self.image, self.x, self.y)
end

--AABB collision
function Dragon:collides(log)
    -- add offset to make the game a bit more forgiving (user experience)
    if (self.x + 8) + (self.width - 16) >= log.x and self.x + 8 <= log.x + LOG_WIDTH then
        if (self.y + 8) + (self.height - 16) >= log.y and self.y + 8 <= log.y + LOG_HEIGHT then
            return true
        end
    end
    return false
end

function Dragon:update(dt)
    self.dy = self.dy + GRAVITY*dt

    if love.keyboard.wasPressed('space') then
        self.dy = -5
    end

    self.y = self.y + self.dy
end