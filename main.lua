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

<<<<<<< HEAD
--funcion para construir pelota
local function newBall(world, x, y)
	local ball = {}
	ball.body = love.physics.newBody(world, x, y, "dynamic")
	ball.shape = love.physics.newCircleShape(ballRadius)
	ball.fixture = love.physics.newFixture(ball.body, ball.shape, 1) -- densidad 1 (mayor densidad es mayor masa)
	ball.fixture:setRestitution(0.9) --pelota rebota
	ball.body:setLinearDamping(0.7)

	return ball
=======
function love.update(dt)
   lovelyMoon.update(dt)
>>>>>>> origin/test_stages
end

function love.draw()
   lovelyMoon.draw()
end

<<<<<<< HEAD
function love.load()
	love.physics.setMeter(32)
	world = love.physics.newWorld(0, 0, true)
	
	objects = {} --objetos del juego

	objects.lbound = newBoundary(world, 5, 240/2, 10, 240) --borde izquierdo
	objects.rbound = newBoundary(world, 315, 240/2, 10, 240)	--borde derecho
	objects.ubound = newBoundary(world, 320/2, 10, 320,20)	--borde superior
	objects.dbound = newBoundary(world, 320/2, 235, 320,10) --borde inferior

	-- crear obstaculos (patas de las sillas)

	objects.obs = {}
	math.randomseed(os.time())
	for i = 0, 25, 1 do
		local o = newObstacle( world, math.random(15, 305), math.random(15, 225))
		table.insert(objects.obs, o)
	end

	-- crear pelota
	objects.ball = newBall(world, 320/2, 240/2)


=======
function love.keypressed(key, unicode)
   lovelyMoon.keypressed(key, unicode)
>>>>>>> origin/test_stages
end

function love.keyreleased(key, unicode)
   lovelyMoon.keyreleased(key, unicode)
end

function love.mousepressed(x, y, button)
   lovelyMoon.mousepressed(x, y, button)
end

<<<<<<< HEAD
	love.graphics.setColor(255, 255, 255)
	if playing then
		love.graphics.print("Player 1", 10, 5)
	elseif not playing then
		love.graphics.print("Waiting...", 10, 5)
	end
	--pelota
	love.graphics.setColor(193, 47, 14)
	love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
=======
function love.mousereleased(x, y, button)
   lovelyMoon.mousereleased(x, y, button)
>>>>>>> origin/test_stages
end