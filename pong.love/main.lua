
-- push library from repo https://github.com/Ulydev/push
push = require 'push'

Class = require 'class'

require 'Paddle'
require 'Ball'

WIN_WIDTH = 1280
WIN_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest','nearest')
    love.window.setTitle('Pong made with LÖVE')
    -- seed the randome number generator
    math.randomseed(os.time())

    sounds = {
        ['hit1'] = love.audio.newSource('sounds/Paddle_1.wav', 'static'),
        ['hit2'] = love.audio.newSource('sounds/Paddle_2.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/Score.wav', 'static'),
        ['wall'] = love.audio.newSource('sounds/wall.wav', 'static'),
        ['win'] = love.audio.newSource('sounds/WIN.wav', 'static')
    }

    smallFont = love.graphics.newFont('font.ttf', 8, 'mono')
    largeFont = love.graphics.newFont('font.ttf', 12, 'mono')
    scoreFont = love.graphics.newFont('font.ttf', 16, 'mono')
    love.graphics.setFont(smallFont)
    -- given to us by love 2d. We override it and give it behaviour.
    -- use Push function here to take virtual w and h into account
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WIN_WIDTH, WIN_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    player1score = 0
    player2score = 0

    servingPlayer = 1
    winningPlayer = 0

    player1 = Paddle(10,30,5,20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    ball = Ball((VIRTUAL_WIDTH / 2) - 2, (VIRTUAL_HEIGHT / 2) - 2, 4, 4)

    gameState = 'start'
end

function love.update(dt)

    --ball initiation in play state
    if gameState == 'serve' then
        ball.dy = math.random(-50,50)
        if servingPlayer == 1 then
            ball.dx = math.random(140,200)
        else
            ball.dx = -math.random(140,200)
        end
    end

    if gameState == 'play' then
        ball:update(dt)
        if ball:collides(player1) then
            sounds['hit1']:play()
            -- speed up the game at every collision for excitement
            ball.dx = -ball.dx * 1.03

            -- avoid infinite collision. Shift ball entirely as reset
            ball.x = player1.x + 5

            -- add variability in angle but maintain direction
            if ball.dy < 0 then
                ball.dy = -math.random(10,150)
            else
                ball.dy = math.random(10,150)
            end
        end

        if ball:collides(player2) then
            sounds['hit2']:play()
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4
            if ball.dy < 0 then
                ball.dy = -math.random(10,150)
            else
                ball.dy = math.random(10,150)
            end
        end

        if ball.y <= 0 then
            sounds['wall']:play()
            ball.y = 0
            ball.dy = -ball.dy
        end

        if ball.y >= VIRTUAL_HEIGHT - 4 then
            sounds['wall']:play()
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
        end

        -- scoring
        if ball.x < 0 then
            servingPlayer = 1
            player2score = player2score + 1
            if player2score == 3 then
                sounds['win']:play()

                winningPlayer = 2
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end
        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1score = player1score + 1
            if player1score == 3 then
                sounds['win']:play()

                winningPlayer = 1
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end
    end

    --player 1 movement
    --if love.keyboard.isDown('w') then
      --player1.dy = -PADDLE_SPEED
    --elseif love.keyboard.isDown('s') then
        --player1.dy = PADDLE_SPEED
    --else
        --player1.dy = 0
    --end
    -- move paddle simple AI
    if gameState == 'play' and ball.dx < 0 and ball.dy > 0 then
        player1.dy = PADDLE_SPEED
        if player1.y > ball.y then
            player1.dy = 0
        end
    elseif gameState == 'play' and ball.dx < 0 and ball.dy < 0 then
        player1.dy = -PADDLE_SPEED
        if player1.y < ball.y then
            player1.dy = 0
        end
    else
        player1.dy = 0
    end

    --player 2 movement
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    player1:update(dt)
    player2:update(dt)

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()

    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' then
            gameState = 'serve'
            -- reinitialise
            ball:reset()
            player1score = 0
            player2score = 0

            -- loser of last round serves next round
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end
end

function love.draw()

    push:apply('start')

    love.graphics.clear(139/255, 34/255, 82/255, 255/255)
    love.graphics.setFont(smallFont)
    displayScore()

    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Hello Pong!\nPress ENTER to serve.',0,5,VIRTUAL_WIDTH,'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. ' to serve.',0,5,VIRTUAL_WIDTH,'center')
        love.graphics.printf('Press ENTER to serve.', 0,15,VIRTUAL_WIDTH,'center')
    elseif gameState == 'play' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Hello Pong!\nPLAY',0,5,VIRTUAL_WIDTH,'center')
    elseif gameState == 'done' then
        love.graphics.setColor(255/255,110/255,199/255, 255/255)

        love.graphics.setFont(largeFont)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' - YOU WIN!',0,5,VIRTUAL_WIDTH,'center')
        love.graphics.setFont(smallFont)
        love.graphics.setColor(1,1,1,1)

        love.graphics.printf('Game Over\nPress ENTER to play again',0,30,VIRTUAL_WIDTH,'center')
    end

    -- first paddle left
    player1:render()

    -- second paddle right
    player2:render()
    -- ball dead center
    ball:render()
    displayFPS()
    push:apply('end')
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(255/255,110/255,199/255, 255/255)
    -- .. is concatinating function
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function displayScore()
    love.graphics.setFont(scoreFont)
        love.graphics.print(tostring(player1score), (VIRTUAL_WIDTH / 2) - 30, VIRTUAL_HEIGHT / 2 - 16 )
        love.graphics.print(tostring(player2score), (VIRTUAL_WIDTH / 2) + 30 - 8, VIRTUAL_HEIGHT / 2 - 16)
end
