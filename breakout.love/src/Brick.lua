Brick = Class {}

function Brick:init(x,y)

    self.tier = 0
    self.colour = 1
    
    -- brick dims
    self.x = x
    self.y = y

    self.width = 32
    self.height = 16

   -- small game not too much memory no problem to use this     
    self.inPlay = true

end

function Brick:hit()
    gSounds['hit1']:play()

    self.inPlay = false
end

function Brick:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'], gFrames['bricks'][1 + ((self.colour - 1) *4) + self.tier], self.x, self.y)
    end
end