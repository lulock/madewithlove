LogPair = Class{}

local GAP_HEIGHT = 90

function LogPair:init(y)

    self.x = VIRTUAL_WIDTH + 32

    self.y = y

    self.logs = {
        ['upper'] = Log('top', self.y),
        ['lower'] = Log('lower', self.y + LOG_HEIGHT + GAP_HEIGHT)
    }

    self.remove = false
end

function LogPair:update(dt)
    if self.x > -LOG_WIDTH then
        self.x = self.x - LOG_SCROLL * dt
        self.logs['lower'].x = self.x
        self.logs['upper'].x = self.x
    else
        self.remove = true
    end
end

function LogPair:render()
    for k, log in pairs(self.logs) do
        log:render()
    end
end