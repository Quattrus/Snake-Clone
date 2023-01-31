function love.load()
    -- initialization 
    love.window.setTitle("snake")
    sound = love.audio.newSource("beep.mp3", "static")
    font = love.graphics.newFont(18)
    score = 0
    speed = 1
    snakewidth = 10
    snakeheight = 10

    -- initialize game
    snake = {{x = 200, y = 200}, {x = 190, y = 200}, {x = 180, y = 200}}
    repositionfood()
    direction = "right"
    gamestatus = "gamestarted"
end

function love.update(dt)
    --setup move direction updates
    if direction == "right" then
        snake[1].x = snake[1].x + speed
    elseif direction == "left" then
        snake[1].x = snake[1].x - speed
    elseif direction == "up" then
        snake[1].y = snake[1].y - speed
    elseif direction == "down" then
        snake[1].y = snake[1].y + speed
    end
    --make the segments follow the head
    for i = #snake, 2, -1 do
        snake[i].x = snake[i-1].x
        snake[i].y = snake[i-1].y
    end

    --check collisions for scoring
    if checkcollision(snake[1].x, snake[1].y, snakewidth, snakeheight, food.x, food.y, snakewidth, snakeheight)  then
        sound:play()
        repositionfood()
        updatescore()
        updatespeed()
        growsnake()
    end

    --check game over collisions
    if checkcollisionself(snake[1].x, snake[1].y) or checkwallupleft(snake[1].x, snake[1].y) or checkwalldownright(snake[1].x + snakewidth, snake[1].y + snakeheight) then
        gamestatus = "gameover"
    end
end

function love.draw()
    --draw font and colors
    love.graphics.setFont(font)
    love.graphics.setBackgroundColor(96/255, 106/255, 65/255)
    love.graphics.setColor(62/255, 57/255, 51/255)

    --draw game over screen
    if gamestatus == "gameover" then
        love.graphics.printf("Game Over", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
        love.graphics.printf("Press (enter) to restart", 0, love.graphics.getHeight() / 2 + 20, love.graphics.getWidth(), "center")
    else
        --draw game screen
        love.graphics.rectangle("fill", food.x, food.y, snakewidth, snakeheight)

    for i, segment in ipairs(snake) do
        love.graphics.rectangle("fill", segment.x, segment.y, snakewidth, snakeheight)
    end

    love.graphics.print("Score: " .. score, 10, 10)
    end
end

function love.keypressed(key)
    if key == "right" and direction ~= "left" then
        direction = "right"
    elseif key == "left" and direction ~= "right" then
        direction = "left"
    elseif key == "up" and direction ~= "down" then
        direction = "up"
    elseif key == "down" and direction ~= "up" then
        direction = "down"
    elseif key == "r" or key == "return" then
        love.load()
    elseif key == "escape" then
        love.event.quit()
    end
end

function checkcollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
        x2 < x1 + w1 and
        y1 < y2 + h2 and 
        y2 < y1 + h1
end

function checkwallupleft(x, y)
    return x < 0 or y < 0
end

function checkwalldownright(x, y)
    return x > love.graphics.getWidth() or y > love.graphics.getHeight() 
end

function repositionfood()
    food = {x = math.random(10, love.graphics.getWidth() - 10), y = math.random(10, love.graphics.getHeight() - 10)}
end

function updatescore()
    score = score + 1
end

function updatespeed()
    speed = speed + 0.05
end

function growsnake()
    snake[#snake+1] = {x = snake[#snake].x, y = snake[#snake].y}
end

function checkcollisionself(x, y)
    for i, segment in ipairs(snake) do
        if i > 2 and x == segment.x and y == segment.y then
            return true
        end
    end
    return false
end
