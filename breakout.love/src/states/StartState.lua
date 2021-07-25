-- [[Following along Harvard's Games50 course. Instructed by Colton Ogden]]

StartState = Class {__includes = BaseState}

local highlighted = 1

function StartState:update(dt)
    -- arrow key up or down toggles highlight option
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        -- toggle 1 or 2 (lua's oneline conditional equivalent to true ? x : y)
        highlighted = highlighted == 1 and 2 or 1
        gSounds['hit1']:play()
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if highlighted == 1 then
            gStateMachine:change('play')
        end
    end

end

function StartState:render()
    -- title 
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("BREAKOUT", 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
    
    -- instructions
    love.graphics.setFont(gFonts['medium'])
    if highlighted == 1 then
        love.graphics.setColor(103/255, 255/255, 255/255, 255/255)
    end

    love.graphics.printf("START", 0, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')

    -- reset the color
    love.graphics.setColor(255,255,255,255)
    
    if highlighted == 2 then
        love.graphics.setColor(103/255, 255/255, 255/255, 255/255)
    end
    
    love.graphics.printf("HIGH SCORES", 0, VIRTUAL_HEIGHT / 2 + 50, VIRTUAL_WIDTH, 'center')

    -- reset the color
    love.graphics.setColor(255,255,255,255)
end