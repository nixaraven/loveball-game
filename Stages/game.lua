--Example of a GameState file

--Table
GameState = {}

-- Scenes variables
playing = true
ballRadius = 5

--funcion para construir borde
local function newBoundary( world, x, y, l, h )
	local bound = {}
	bound.body = love.physics.newBody(world, x, y, "static") -- crea cuerpo
	bound.shape = love.physics.newRectangleShape(l,h) -- crea rectangulo
	bound.fixture = love.physics.newFixture(bound.body, bound.shape) --asociando cuerpo y rectangulo

	return bound
end

--funcion para construir pelota
local function newBall(world, x, y)
	local ball = {}
	ball.body = love.physics.newBody(world, x, y, "dynamic")
	ball.shape = love.physics.newCircleShape(ballRadius)
	ball.fixture = love.physics.newFixture(ball.body, ball.shape, 1) -- densidad 1 (mayor densidad es mayor masa)
	ball.fixture:setRestitution(0.5) --pelota rebota
	ball.body:setLinearDamping(0.5)
	ball.score = 0

	return ball
end

--funcion para construir obstaculo
local function newObstacle( world, x, y )
	local obs = {}
	obs.body = love.physics.newBody(world, x, y, "static")
	obs.shape = love.physics.newCircleShape(3)
	obs.fixture = love.physics.newFixture(obs.body, obs.shape)

	return obs
end

--New
function GameState:new()
   local gs = {}

   gs = setmetatable(gs, self)
   self.__index = self
   _gs = gs
   
   return gs
end

--Load
function GameState:load()
	love.window.setTitle("3 Player game")
	player_id = 1
	playing = true
	delay = false
	text = "Score "
	timer = 240
	t = 0
	
	love.physics.setMeter(32)
	world = love.physics.newWorld(0, 0, true)
		world:setCallbacks(beginContact)
	
	objects = {} --objetos del juego

	objects.lbound = newBoundary(world, 5, 240/2, 10, 240) --borde izquierdo
	objects.rbound = newBoundary(world, 315, 240/2, 10, 240)	--borde derecho
	objects.ubound = newBoundary(world, 320/2, 5, 320,10)	--borde superior
	objects.dbound = newBoundary(world, 320/2, 235, 320,10) --borde inferior

	-- crear obstaculos (patas de las sillas)

	objects.obs = {}
	math.randomseed(os.time())
	for i = 0, 25, 1 do
		local o = newObstacle( world, math.random(15, 305), math.random(15, 225))
		table.insert(objects.obs, o)
	end

	-- crear pelotas
	objects.balls = {}
	local y = 10
	local x = 10
	for i = 0, 2, 1 do
		local local_ball = newBall(world, y, x)
		local_ball.fixture:setUserData("Ball_Player_"..i)
		table.insert(objects.balls, local_ball)
		x = x + 50
		y = y + 50
	end
	--objects.ball = newBall(world, 320/2, 240/2)
end

--Close
function GameState:close()
end

--Enable
function GameState:enable()
end

--Disable
function GameState:disable()
end

--Update
function GameState:update(dt)
	world:update(dt)
	
	if t > 60 then
		t = 0
		timer = timer - 1
	end
	t = t + 1
	
	if timer == 0 then
		switchState("game", "menu")
	end
	
	--delay
	if delay then
		n = n + 1
		if n > 500 then
			delay = false
		end
	end
	
	if not delay then
		-- Determinar el jugador activo
		if not playing then
			player_id = player_id + 1
			if player_id > 3 then
				player_id = 1
			end
			playing = true
		end
		
		-- estado para determinar la direccion de la pelota
		quietas = 0
		for i, ball in ipairs(objects.balls) do
			vx, vy = ball.body:getLinearVelocity()
			if  (vx < 0.01) and (vy < 0.01) then
				quietas = quietas + 1
			end
		end
		if quietas == 3 then
			playing = true
		end
		
		if playing then
			if love.keyboard.isDown(" ") then
				--eventos de teclado
				for i, ball in ipairs(objects.balls) do
					if i == player_id then
						if love.keyboard.isDown("up") then ball.body:applyForce(0, -400) end
						if love.keyboard.isDown("up") and love.keyboard.isDown("right") then ball.body:applyForce(400, -400) end
						if love.keyboard.isDown("right") then ball.body:applyForce(400, 0) end
						if love.keyboard.isDown("right") and love.keyboard.isDown("down") then ball.body:applyForce(400, 400) end
						if love.keyboard.isDown("down") then ball.body:applyForce(0, 400) end    		
						if love.keyboard.isDown("down") and love.keyboard.isDown("left") then ball.body:applyForce(-400, 400) end
						if love.keyboard.isDown("left") then ball.body:applyForce(-400, 0) end
						if love.keyboard.isDown("left") and love.keyboard.isDown("up") then ball.body:applyForce(-400, -400) end
						playing = false
						delay = true
						n = 0
					end
				end
			end
		end
	end
end

--Manejo Colisiones
function beginContact(a, b, coll)
    x,y = coll:getNormal()
	if a:getUserData() and b:getUserData() then
		for i, ball in ipairs(objects.balls) do
			if player_id == i then
				ball.score = ball.score + 50
			end
		end
		playing = true
	end
end

--Draw
function GameState:draw()
		love.graphics.setBackgroundColor(104, 136, 248) --color de fondo

	--bordes
	love.graphics.setColor(0, 0, 0)
	love.graphics.polygon("fill", objects.lbound.body:getWorldPoints(objects.lbound.shape:getPoints()))
	love.graphics.polygon("fill", objects.rbound.body:getWorldPoints(objects.rbound.shape:getPoints()))
	love.graphics.polygon("fill", objects.ubound.body:getWorldPoints(objects.ubound.shape:getPoints()))
	love.graphics.polygon("fill", objects.dbound.body:getWorldPoints(objects.dbound.shape:getPoints()))

	--obstaculos
	for i, obstacle in ipairs(objects.obs) do
		love.graphics.circle("fill", obstacle.body:getX(), obstacle.body:getY(), obstacle.shape:getRadius())
	end

	if playing then
		texto =  "Player "..tostring(player_id)
		local scores = 0
		love.graphics.setColor(255, 255, 255)
		love.graphics.print(texto, 5, 5)
		for i, ball in ipairs(objects.balls) do
			if player_id == i then
				scores = ball.score
			end
		end
		love.graphics.printf(text..scores, 115, 5, 200, "right")
		love.graphics.printf(timer, 60, 5, 200, "center")
	end
	--pelota
	local a = 193
	local b = 14
	love.graphics.setColor(a, 47, b)
	for i, ball in ipairs(objects.balls) do
		love.graphics.circle("fill", ball.body:getX(), ball.body:getY(), ball.shape:getRadius())
		a = a - 50
		b = b * 2
		love.graphics.setColor(a, 47, b)
	end
end

--KeyPressed
function GameState:keypressed(key, unicode)
end

--KeyReleased
function GameState:keyreleased(key, unicode)
end

--MousePressed
function GameState:mousepressed(x, y, button)
end

--MouseReleased
function GameState:mousereleased(x, y, button)
end