PlayState = Class{__includes = BaseState}

LOG_SCROLL = 60

LOG_HEIGHT = 219
LOG_WIDTH = 35

function PlayState:init()
    self.dragon = Dragon()
    self.logPairs = {}
    self.timer = 0

    self.lastY = -LOG_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    self.timer = self.timer + dt
    -- spawn first log after 2 seconds
    if self.timer > 2 then
    
        local y = math.max(-LOG_HEIGHT + 10, math.min(self.lastY + math.random(-20,20), VIRTUAL_HEIGHT- 90 - LOG_HEIGHT))
        self.lastY = y
    
        table.insert(self.logPairs, LogPair(y))
        self.timer = 0
    end
    
    for k, pair in pairs(self.logPairs) do 
        pair:update(dt)
    end
    
    for k, pair in pairs(self.logPairs) do
        if pair.remove then
            table.remove(self.logPairs, k)
        end
    end
    self.dragon:update(dt)

    -- collision
    for k, pair in pairs(self.logPairs) do 
        for l, log in pairs(pair.logs) do
            if self.dragon:collides(log) then
                gStateMachine:change('title')
            end
        end
    end

    if self.dragon.y > VIRTUAL_HEIGHT - 15 then
        gStateMachine:change('title')
    end

end

function PlayState:render()
    for k, pair in pairs(self.logPairs) do 
        pair:render()
    end

    self.dragon:render()
end