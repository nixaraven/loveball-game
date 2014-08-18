--Intentando hacer la cosa con LÖVE2d
-- por que no con pygame? se veia mas facil love, ademas es simple crear un ejecutable
-- tutorial fisicas = https://love2d.org/wiki/Tutorial:Physics
-- tutoriales love2d y lua http://gamedevelopment.tutsplus.com/articles/how-to-learn-love-love2d--gamedev-4331

--love.window.setMode(320,240, {fullscreen = true})
love.window.setMode(320,240)
love.window.setTitle("JuegoSinNombre")
math.randomseed(os.time())

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
local function newBall(world)
	local ball = {}
	ball.body = love.physics.newBody(world, math.random(15, 305), math.random(20, 225), "dynamic")
	ball.shape = love.physics.newCircleShape(ballRadius)
	ball.fixture = love.physics.newFixture(ball.body, ball.shape, 1) -- densidad 1 (mayor densidad es mayor masa)
	ball.fixture:setRestitution(0.5) --pelota rebota
	ball.body:setLinearDamping(0.5)

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

function love.load()
	love.physics.setMeter(32)
	world = love.physics.newWorld(0, 0, true)
		world:setCallbacks(beginContact, endContact, preSolve, postSolve)
	
	objects = {} --objetos del juego

	objects.lbound = newBoundary(world, 5, 240/2, 10, 240) --borde izquierdo
	objects.rbound = newBoundary(world, 315, 240/2, 10, 240)	--borde derecho
	objects.ubound = newBoundary(world, 320/2, 10, 320,20)	--borde superior
	objects.dbound = newBoundary(world, 320/2, 235, 320,10) --borde inferior

	-- crear obstaculos (patas de las sillas)

	objects.obs = {}
	for i = 0, 25, 1 do
		local o = newObstacle( world, math.random(15, 305), math.random(20, 225))
		table.insert(objects.obs, o)
	end

	-- crear pelota
	objects.ball = newBall(world)
	objects.ball2 = newBall(world)
	objects.ball3 = newBall(world)

	counter = 0

	collisionFlag = false
	collisionBall = objects.ball


end

function love.update(dt)
	world:update(dt)


    -- estado para determinar la direccion de la pelota
    vx, vy = objects.ball.body:getLinearVelocity()
    if  (vx < 0.08) and (vy < 0.08) then
	    vx, vy = objects.ball2.body:getLinearVelocity()
	    if  (vx < 0.08) and (vy < 0.08) then
		    vx, vy = objects.ball3.body:getLinearVelocity()
		    if  (vx < 0.08) and (vy < 0.08) then
		    	playing = true
		    end
	    end
    end

    if playing then
    	if counter % 3 == 0 then currentBall = objects.ball
    	elseif counter % 3 == 1 then currentBall = objects.ball2
    	elseif counter % 3 == 2 then currentBall = objects.ball3
    	end

    	if love.keyboard.isDown(" ") and playing then
			--eventos de teclado
			if love.keyboard.isDown("right") then currentBall.body:applyForce(400, 0) end
		    if love.keyboard.isDown("left") then currentBall.body:applyForce(-400, 0) end
		    if love.keyboard.isDown("up") then currentBall.body:applyForce(0, -400) end
		    if love.keyboard.isDown("down") then currentBall.body:applyForce(0, 400) end    

	    	playing = false
		    counter = counter + 1		
    	end
    end

end

function love.draw()
	love.graphics.setBackgroundColor(0, 87, 132) --color de fondo

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

	love.graphics.setColor(255, 255, 255)
	if playing then
		if currentBall == objects.ball then
			love.graphics.setColor(193, 47, 14)
			love.graphics.print("Player 1", 5, 5)
		elseif currentBall == objects.ball2 then
			love.graphics.setColor(235, 137, 49)
			love.graphics.print("Player 2", 5, 5)
		elseif currentBall == objects.ball3 then
			love.graphics.setColor(163, 206, 39)
			love.graphics.print("Player 3", 5, 5)
		end
	else
		love.graphics.print("Wait...", 5, 5)
	end
	--dibujando pelotas
	love.graphics.setColor(193, 47, 14)
	love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
	love.graphics.setColor(235, 137, 49)
	love.graphics.circle("fill", objects.ball2.body:getX(), objects.ball2.body:getY(), objects.ball2.shape:getRadius())
	love.graphics.setColor(163, 206, 39)
	love.graphics.circle("fill", objects.ball3.body:getX(), objects.ball3.body:getY(), objects.ball3.shape:getRadius())
end

function beginContact(a, b, coll)
	if a:getBody():getType() == "dynamic" and b:getBody():getType() == "dynamic" then

		if collisionFlag and a ~= collisionBall and  b ~= collisionBall then
			--AQUI SE GANA EL JUEGO, ME DA PAJA APRENDER LAS COSAS DE LOS ESTADOS
		end

		if a == currentBall.fixture then collisionBall = b end
		if b == currentBall.fixture then collisionBall = a end

		collisionFlag = true
	end
end

function endContact(a, b, coll)
end

function preSolve(a, b, coll)
end

function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
end