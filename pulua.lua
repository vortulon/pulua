-- pulua game (its really buggy lol)
local width, height = 20, 10
local snake = {{x = 5, y = 5}}
local food = {x = math.random(1, width), y = math.random(1, height)}
local direction = "right"
local score = 0

-- function to clear the terminal screen
local function clear_screen()
    if os.getenv("OS") == "Windows_NT" then
        os.execute("cls") -- for windows
    else
        os.execute("clear") -- for unix/linux/mac
    end
end

-- function to draw the game board
local function draw()
    clear_screen()
    for y = 1, height do
        for x = 1, width do
            local is_snake = false
            for _, segment in ipairs(snake) do
                if segment.x == x and segment.y == y then
                    is_snake = true
                    break
                end
            end
            if is_snake then
                io.write("\27[42mo\27[0m") -- green snake
            elseif x == food.x and y == food.y then
                io.write("\27[41mx\27[0m") -- red food
            else
                io.write(".")
            end
        end
        io.write("\n")
    end
    print("score: " .. score)
    print("use w, a, s, d to move. press q to quit.")
end

-- function to update the game state
local function update()
    local head = {x = snake[1].x, y = snake[1].y}

    -- update head position based on direction
    if direction == "up" then
        head.y = head.y - 1
    elseif direction == "down" then
        head.y = head.y + 1
    elseif direction == "left" then
        head.x = head.x - 1
    elseif direction == "right" then
        head.x = head.x + 1
    end

    -- check for collision with walls
    if head.x < 1 or head.x > width or head.y < 1 or head.y > height then
        print("\27[31mgame over! final score: " .. score .. "\27[0m")
        os.exit()
    end

    -- check for collision with itself
    for i = 2, #snake do
        if snake[i].x == head.x and snake[i].y == head.y then
            print("\27[31mgame over! final score: " .. score .. "\27[0m")
            os.exit()
        end
    end

    -- insert new head position
    table.insert(snake, 1, head)

    -- check if snake eats food
    if head.x == food.x and head.y == food.y then
        score = score + 1
        food = {x = math.random(1, width), y = math.random(1, height)}
    else
        table.remove(snake) -- remove tail if no food eaten
    end
end

-- function to handle user input
local function input()
    -- this is annoying
    local key = io.read()
    if key == "w" and direction ~= "down" then
        direction = "up"
    elseif key == "s" and direction ~= "up" then
        direction = "down"
    elseif key == "a" and direction ~= "right" then
        direction = "left"
    elseif key == "d" and direction ~= "left" then
        direction = "right"
    elseif key == "q" then
        print("\27[31mquitting game...\27[0m")
        os.exit()
    end
end

-- main game loop
print("welcome to pulua!")
while true do
    draw()
    update()
    input()
end
