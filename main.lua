--Intentando hacer la cosa con LÖVE2d
-- por que no con pygame? se veia mas facil love, ademas es simple crear un ejecutable
-- tutorial fisicas = https://love2d.org/wiki/Tutorial:Physics
-- tutoriales love2d y lua http://gamedevelopment.tutsplus.com/articles/how-to-learn-love-love2d--gamedev-4331

--love.window.setMode(320,240, {fullscreen = true})
love.window.setMode(320,240)
love.window.setTitle("JuegoSinNombre")

--funcion para construir borde
local function newBoundary( world, x, y, l, h )
	local bound = {}
	bound.body = love.physics.newBody(world, x, y, "static") -- crea cuerpo
	bound.shape = love.physics.newRectangleShape(l,h) -- crea rectangulo
	bound.fixture = love.physics.newFixture(bound.body, bound.shape) --asociando cuerpo y rectangulo

	return bound
end

--funcion para construir pelota
local function newBall(world, x, y, radius)
	local ball = {}
	ball.body = love.physics.newBody(world, x, y, "dynamic")
	ball.shape = love.physics.newCircleShape(radius)
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
	
	objects = {} --objetos del juego

	objects.lbound = newBoundary(world, 5, 240/2, 10, 240) --borde izquierdo
	objects.rbound = newBoundary(world, 315, 240/2, 10, 240)	--borde derecho
	objects.ubound = newBoundary(world, 320/2, 5, 320,10)	--borde superior
	objects.dbound = newBoundary(world, 320/2, 235, 320,10) --borde inferior

	-- crear obstaculos (patas de las sillas)

	objects.obs = {}
	math.randomseed(os.time())
	for i = 0, 20, 1 do
		local o = newObstacle( world, math.random(15, 305), math.random(15, 225))
		table.insert(objects.obs, o)
	end

	-- crear pelota
	objects.ball = newBall(world, 320/2, 240/2, 5)


end

function love.update(dt)
	world:update(dt)

	--no hay roce, hacerlo de alguna manera

	--eventos de teclado
	if love.keyboard.isDown("right") then objects.ball.body:applyForce(400, 0) end
    if love.keyboard.isDown("left") then objects.ball.body:applyForce(-400, 0) end
    if love.keyboard.isDown("up") then objects.ball.body:applyForce(0, -400) end
    if love.keyboard.isDown("down") then objects.ball.body:applyForce(0, 400) end
end

function love.draw()
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

	--pelota
	love.graphics.setColor(193, 47, 14)
	love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
end