local level = {}

local field = {}
field.w = 30
field.h = 40

local board = {}
board.x = 0
board.y = 0
board.w = 100

local balls = {}

level.field = field
level.board = board

grid_visible = false

function newBall(x, y, velx, vely, r)
	local ball = {}
	table.insert(balls, ball)

	ball.x = x or 100
	ball.y = y or 100
	ball.velx = velx or 300
	ball.vely = vely or 300
	ball.r = r or 10
	ball.ax = 0
	ball.ay = 0
	return ball
end

function newExplosion(x, y, dir, power)
	power = power or 0.5
	p = g.newParticleSystem(part1, 1000)
	table.insert(explosions, p)
	p:setEmissionRate(1000 * power)
	p:setSpeed(400 - 400*power, 600*power)
	p:setSizes(1, 0.5)
	p:setColors(220, 105, 20, 255*power, 194, 30, 18, 0)
	p:setPosition(x, y)
	p:setLifetime(0.15*power)
	p:setParticleLife(0.1 + 0.1 * power)
	p:setDirection(dir or 0)
	p:setSpread(2)
	p:setTangentialAcceleration(-1000, 1000)
	p:setRadialAcceleration(-1000 * power)
	p:setGravity(2000)
	p:start()
end

function level.load()
	board.x = g.getWidth()/2

	local ball = newBall()
	ball.x = 200
	ball.y = 200
	ball.velx = 30
	ball.vely = 30
	ball.r = 10
	
	ball = newBall()
	ball.x = 300
	ball.velx = 5
	ball.vely = 16

--	ball = newBall()
--	ball.x = 500
--	ball.velx = 120
--	ball.vely = 200
--	ball.ps = ball_ps
end

function level.update(dt)
	local w = g.getWidth()
	local h = g.getHeight()

	board.x = love.mouse.getX()-board.w/2
	if board.x < 0 then board.x = 0 end
	if board.x+board.w > w then board.x = w-board.w end

	for i, ball in ipairs(balls) do
		--apply gravity to acceleration
		ball.ax = 0
		ball.ay = 0
		for k, ball2 in ipairs(balls) do
			if k ~= i then
				local d = math.sqrt(ball2.x*ball2.x+ball2.y*ball2.y)
				local dx = ball2.x - ball.x
				local dy = ball2.y - ball.y
				local ax = 1000/dx/d
				local ay = 1000/dy/d
				if ax > 100 then ax = 100 end
				if ay > 100 then ay = 100 end
				ball.ax = ball.ax + ax
				ball.ay = ball.ay + ay
			end
		end

		--apply acceleration to velocity
		ball.velx = ball.velx + ball.ax*dt
		ball.vely = ball.vely + ball.ay*dt
		
		--apply velocity to position
		ball.x = ball.x + dt*ball.velx
		ball.y = ball.y + dt*ball.vely

		--check collisions
		local powerx = math.abs(ball.velx) / 500
		local powery = math.abs(ball.vely) / 500
		if ball.x-ball.r <= 0 then 
			ball.x = ball.r; ball.velx = -ball.velx; 
			newExplosion(0, ball.y, 0, powerx)
		end
		if ball.y-ball.r <= 0 then 
			ball.y = ball.r; ball.vely = -ball.vely;
			newExplosion(ball.x, 0, math.pi/2, powery)
		end
		if ball.x+ball.r >= w then 
			ball.x = w-ball.r; ball.velx = -ball.velx;
			newExplosion(w, ball.y, math.pi, powerx)
		end
		if ball.y+ball.r >= h then 
			ball.y = h-ball.r; ball.vely = -ball.vely;
			newExplosion(ball.x, h, -math.pi/2, powery)
		end

		if ball.ps then
			ball.ps:setPosition(ball.x, ball.y)
			ball.ps:update(dt)
		end
	end
end

function draw_grid()
	g.setColor(255,255,255, 32)
	for x = 0, g.getWidth(), 16 do
		g.line(x, 0, x, g.getHeight())
	end
	for y = 0, g.getHeight(), 16 do
		g.line(0, y, g.getWidth(), y)
	end
end

function level.draw()
	if grid_visible then draw_grid() end
	g.reset()
	g.rectangle("fill", board.x, g.getHeight()-16, board.w, 16)

	for _, ball in ipairs(balls) do
		if ball.ps then
			g.setBlendMode("additive")
			g.draw(ball.ps, 0, 0)
		else
			g.circle("fill", ball.x, ball.y, ball.r, 32)
			g.line(ball.x, ball.y, ball.x+ball.ax, ball.y+ball.ay)
		end
	end
end

function level.keypressed(key)
	if key == "g" then
		grid_visible = not grid_visible
	end
end

return level
