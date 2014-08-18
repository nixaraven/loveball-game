-- State Manager [LovelyMoon - https://love2d.org/forums/viewtopic.php?f=5&t=38702&p=111082]
require("libs/stateManager")
require("libs/lovelyMoon")

-- Stages
require("Stages/game")
require("Stages/menu")

function love.load()
   -- Registrar los distintos Stages aca
   addState(MenuState, "menu")
   addState(GameState, "game")
   
   -- Habilitar el primer Stage
   enableState("menu")

   -- Definicion Height y Width
   love.window.setMode(320,240)

   ---- Cargar assets para todas las stages
   -- Fuente de 8bits
   font = love.graphics.newFont("assets/gamefont.TTF", 10)
   love.graphics.setFont(font)

   -- Musica
   source = love.audio.newSource("assets/bgm.ogg", "stream" )
   love.audio.play(source)

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