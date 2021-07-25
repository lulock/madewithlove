-- [[Following along Harvard's Games50 course. Instructed by Colton Ogden]]


require 'src/Dependencies'


function love.load()

    love.graphics.setDefaultFilter('nearest','nearest')
    love.window.setTitle('Breakout made with LÖVE')
    -- seed the random number generator
    math.randomseed(os.time())

    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8, 'mono'),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 12, 'mono'),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 16, 'mono'),
    }
    
    love.graphics.setFont(gFonts['small'])
    
    gTextures = {
        ['bg'] = love.graphics.newImage('graphics/bg.png'),
        ['main'] = love.graphics.newImage('graphics/breakout.png')
        -- ['arrows'] = love.graphics.newImage('graphics/arrow.png')
        -- ['hearts'] = love.graphics.newImage('graphics/heart.png')
        -- ['particles'] = love.graphics.newImage('graphics/particle.png')
    }

    gFrames = {
        ['paddles'] = GenerateQuadsPaddles(gTextures['main']),
        ['balls'] = GenerateQuadsBalls(gTextures['main']),
        ['bricks'] = GenerateQuadsBricks(gTextures['main'])
    }

    -- given to us by love 2d. We override it and give it behaviour.
    -- use Push function here to take virtual w and h into account
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
    
    gSounds = {
        ['hit1'] = love.audio.newSource('sounds/Paddle_1.wav', 'static'),
        ['pause'] = love.audio.newSource('sounds/Paddle_2.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/Score.wav', 'static'),
        ['wall'] = love.audio.newSource('sounds/wall.wav', 'static'),
        ['win'] = love.audio.newSource('sounds/WIN.wav', 'static')
    }

    -- state machine used to transition between states in game
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end
    }
    gStateMachine:change('start')

    -- keep track of keys that have been pressed this frame using table
    love.keyboard.keysPressed = {}
end

function love.resize(w,h)
    push:resize(w, h)
end

function love.update(dt)
    -- using state object, pass in dt

    gStateMachine:update(dt)

    -- reset KeysPressed
    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    -- if key == 'escape' then
    --     love.event.quit()

    -- elseif key == 'enter' or key == 'return' then
    --     if gameState == 'start' then
    --         gameState = 'serve'
    --     elseif gameState == 'serve' then
    --         gameState = 'play'
    --     elseif gameState == 'done' then
    --         gameState = 'serve'
    --         -- reinitialise
    --         ball:reset()
    --         player1score = 0
    --         player2score = 0

    --         -- loser of last round serves next round
    --         if winningPlayer == 1 then
    --             servingPlayer = 2
    --         else
    --             servingPlayer = 1
    --         end
    --     end
    -- end
end

--[[
    custom copy of default `love.keypressed` callback, 
    bc can't call that logic elsewhere by default.
    ]]

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.draw()

    push:apply('start')

    -- draw bg regardless of state
    local bgWidth = gTextures['bg']:getWidth()
    local bgHeight = gTextures['bg']:getHeight()

    love.graphics.draw(gTextures['bg'], 0,0, 0, VIRTUAL_WIDTH/ (bgWidth - 1), VIRTUAL_HEIGHT / (bgHeight - 1))

    gStateMachine:render()

    displayFPS()

    push:apply('end')
end

function displayFPS()
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0,1,0,1)
    -- .. is concatinating function
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end
