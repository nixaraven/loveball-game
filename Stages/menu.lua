--Table
-- MenuState es el nombre de la Stage
MenuState = {}

-- New
-- No lo toquen
function MenuState:new()
   local gs = {}

   gs = setmetatable(gs, self)
   self.__index = self
   _gs = gs
   
   return gs
end

--Load
function MenuState:load()
	love.window.setTitle("Chocando Pelotas - Alpha 0.1")

	-- Carga de imagenes
	background = love.graphics.newImage("assets/background.png")
end

--Close
function MenuState:close()
end

--Enable
function MenuState:enable()
end

--Disable
function MenuState:disable()
end

--Update
function MenuState:update(dt)
	if love.keyboard.isDown("return") then
    switchState("menu", "game")
  end
end

--Draw
counter = 0
blink_text = true

function MenuState:draw()
  -- Agregar contador
  counter = counter + 1

	-- Fondo del juego
  love.graphics.draw(background, 0, 0)

  ---- Letras
  -- Font: Presionar ENTER para comenzar
  if counter % 44 == 0 then
    blink_text = not blink_text
  end
  if blink_text then
    love.graphics.setColor(0, 0, 0, 255)
  else
    love.graphics.setColor(0, 0, 0, 0)
  end
  love.graphics.printf("Presiona la tecla\n [ enter ] \npara comenzar", 60, 110, 200, 'center')

  -- Font: High Score
  love.graphics.setColor(54, 35, 164, 255)
  love.graphics.printf("Puntaje mayor es de\nDUMMY 250 puntos", 60, 150, 200, 'center')


  -- Resetear el color
  love.graphics.setColor(255,255,255)
end

--KeyPressed
function MenuState:keypressed(key, unicode)
end

--KeyReleased
function MenuState:keyreleased(key, unicode)
end

--MousePressed
function MenuState:mousepressed(x, y, button)
end

--MouseReleased
function MenuState:mousereleased(x, y, button)
end