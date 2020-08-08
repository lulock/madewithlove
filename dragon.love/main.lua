push = require 'push'
Class = require 'class'
require 'Dragon'

require 'Log'

require 'LogPair'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('bg-3.png')

local fgScroll = 0

local ground = love.graphics.newImage('ground.png')

local groundScroll = 0

local FG_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local FG_LOOPING_POINT = 512

local dragon = Dragon()

local logPairs = {}

local spawnTimer = 0

local lastY = -LOG_HEIGHT + math.random(80) + 20

function love.load()
    love.graphics.setDefaultFilter('nearest','nearest')

    love.window.setTitle('Dragon')

    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = false
    })

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
    fgScroll = (fgScroll + FG_SCROLL_SPEED * dt) % FG_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % (VIRTUAL_WIDTH)

    dragon:update(dt)

    for k, pair in pairs(logPairs) do 
        pair:update(dt)
    end
    
    for k, pair in pairs(logPairs) do 
        if pair.remove then
            table.remove(logPairs,k)
        end
    end

    spawnTimer = spawnTimer + dt

    if spawnTimer > 2 then

        local y = math.max(-LOG_HEIGHT + 10, math.min(lastY + math.random(-20,20), VIRTUAL_HEIGHT- 90 - LOG_HEIGHT))
        lastY = y
        
        table.insert(logPairs, LogPair(y))
        spawnTimer = 0
    end

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    love.graphics.draw(background, -fgScroll, 0)
    
    for k, pair in pairs(logPairs) do 
        pair:render()
    end

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT-(80*0.4),0,1,0.4)
    dragon:render()
    
    push:finish()
end