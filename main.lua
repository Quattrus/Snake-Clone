function love.load()
    love.window.setTitle("snake")
    snake = {{x = 200, y = 200}, {x = 190, y = 200}, {x = 180, y = 200}}
    repositionfood()
    score = 0
    speed = 1
    direction = "right"
    gamestatus = "gamestarted"
    font = love.graphics.newFont(18)
end

function love.update(dt)
    if direction == "right" then
        snake[1].x = snake[1].x + speed
    elseif direction == "left" then
        snake[1].x = snake[1].x - speed
    elseif direction == "up" then
        snake[1].y = snake[1].y - speed
    elseif direction == "down" then
        snake[1].y = snake[1].y + speed
    end

    --update segments
    for i = #snake, 2, -1 do --for i in the length of snake
    snake[i].x = snake[i-1].x
    snake[i].y = snake[i-1].y
    end

    if checkcollision(snake[1].x, snake[1].y, 10, 10, food.x, food.y, 10, 10)  then
        repositionfood()
        updatescore()
        updatespeed()
        growsnake()
    end

    if checkcollisionself(snake[1].x, snake[1].y) then
        gamestatus = "gameover"
    end

    if checkwallupleft(snake[1].x, snake[1].y) or checkwalldownright(snake[1].x, snake[1].y) then
        gamestatus = "gameover"
    end
end

function love.draw()
    love.graphics.setFont(font)
    if gamestatus == "gameover" then
        love.graphics.print("Game over", love.graphics.getWidth() / 2 - 60, love.graphics.getHeight() / 2)
        love.graphics.print("Press (r) to restart.", love.graphics.getWidth() / 2 - 90, love.graphics.getHeight() / 2 + 30);
    else
    love.graphics.rectangle("fill", food.x, food.y, 10, 10)
    for i, segment in ipairs(snake) do
    love.graphics.rectangle("fill", segment.x, segment.y, 10, 10)
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
    elseif key == "r" then
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
    speed = speed + 0.2
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
