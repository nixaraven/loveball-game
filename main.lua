-- State Manager
require("libs/stateManager")
require("libs/lovelyMoon")

-- Stages
require("Stages/game")

function love.load()
   --Add Gamestates Here
   --addState(MenuState, "menu")
   addState(GameState, "game")
   
   --Remember to Enable your Gamestates!
   enableState("game")
end

function love.update(dt)
   lovelyMoon.update(dt)
end

function love.draw()
   lovelyMoon.draw()
end

function love.keypressed(key, unicode)
   lovelyMoon.keypressed(key, unicode)
end

function love.keyreleased(key, unicode)
   lovelyMoon.keyreleased(key, unicode)
end

function love.mousepressed(x, y, button)
   lovelyMoon.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
   lovelyMoon.mousereleased(x, y, button)
end