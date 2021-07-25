-- [[Following along Harvard's Games50 course. Instructed by Colton Ogden]]

StateMachine = Class {}

function StateMachine:init(states)
    self.empty = {
        render = function() end,
        update = function() end,
        enter = function() end,
        exit = function() end,
    }

    self.states = states or {} -- [name] -> [func that returns states]
    self.current = self.empty
end

function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName]) -- the state must exist
    self.current:exit()
    self.current = self.states[stateName]()
    self.current:enter(enterParams)
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end