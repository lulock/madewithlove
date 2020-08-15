push = require 'push'
Class = require 'class'
require 'Dragon'
require 'Log'
require 'LogPair'

-- game state code
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'

-- screen dims
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual res
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288


local background = love.graphics.newImage('bg-3.png')

local fgScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local FG_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local FG_LOOPING_POINT = 512

-- pause when collision occurs
local scrolling = true

-- gap placement to base other gaps
local lastY = -LOG_HEIGHT + math.random(80) + 20

function love.load()
    love.graphics.setDefaultFilter('nearest','nearest')

    love.window.setTitle('Dragon')

    -- fonts
    smallFont = love.graphics.newFont('font.ttf',8, 'mono')
    mediumFont = love.graphics.newFont('font.ttf',14, 'mono')
    dragonFont = love.graphics.newFont('font.ttf',28, 'mono')
    hugeFont = love.graphics.newFont('font.ttf',56, 'mono')
    love.graphics.setFont(dragonFont)

    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = false
    })

    --initialise state machine
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
    }
    gStateMachine:change('title')

    love.keyboard.keysPressed = {}
end

function love.resze(w,h)
    push:resize(w,h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    -- scroll graphics (global feature of the game)
    fgScroll = (fgScroll + FG_SCROLL_SPEED * dt) % FG_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % (VIRTUAL_WIDTH)
    
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}    
end

function love.draw()
    push:start()
    love.graphics.draw(background, -fgScroll, 0)
    
    gStateMachine:render()

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT-(80*0.4),0,1,0.4)
        
    push:finish()
end