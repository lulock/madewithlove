Paddle = Class {}

function Paddle:init()

    -- paddle dims
    self.x = VIRTUAL_WIDTH / 2 - 32
    self.y = VIRTUAL_HEIGHT - 32

    -- no velocity to start
    self.dx = 0

    -- starting dims
    self.width = 64
    self.height = 16

    -- to change colour
    self.skin = 4

    self.size = 2

end

function Paddle:update(dt)

    -- keyboard input left and right

    if love.keyboard.isDown('left') then
        self.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        self.dx = PADDLE_SPEED
    else
        self.dx = 0
    end

    -- clamp input to left and right side of screen
    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end
end

function Paddle:render()
    love.graphics.draw(gTextures['main'], gFrames['paddles'][self.size + 4 * (self.skin - 1)], self.x, self.y)
end
