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

function newBall(x, y, velx, vely, r, m)
	local ball = {}
	table.insert(balls, ball)

	ball.x = x or 100
	ball.y = y or 100
	ball.velx = velx or 0
	ball.vely = vely or 0
	ball.r = r or 10
	ball.m = m or 400
	ball.pole = 1
	ball.ax = 0
	ball.ay = 0
	return ball
end

function newExplosion(x, y, dir, power)
	power = power or 0.5
	if power > 1 then power = 1 end
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
	ball.velx = 0--300
	ball.vely = 0--300
	ball.r = 10
	
	ball = newBall()
	ball.x = 300
	ball.velx = 0--50
	ball.vely = 0--160
	ball.pole = -1

	ball = newBall()
	ball.x = 500
	ball.velx = 0--120
	ball.vely = 0--200
	ball.ps = ball_ps
	ball.m = 1	
	ball.pole = -1
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
				local dx = ball2.x - ball.x
				local dy = ball2.y - ball.y
				if math.abs(dx) < 5 then dx = w end
				if math.abs(dy) < 5 then dy = h end
				local d = math.sqrt(dx*dx+dy*dy)
				local koef = -150*ball.m*ball2.m/d/d * ball.pole*ball2.pole
				local ax = dx*koef
				local ay = dy*koef
				ball.ax = ball.ax + ax
				ball.ay = ball.ay + ay
			end
		end

		--apply acceleration to velocity
		ball.velx = ball.velx + ball.ax*dt/ball.m
		ball.vely = ball.vely + ball.ay*dt/ball.m

		--limit velocity
		if ball.velx > w then ball.velx = w end
		if ball.vely > h then ball.vely = h end
		
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
			if ball.pole == 1 then
				g.setColor(255, 0, 0)
			else
				g.setColor(0, 0, 255)
			end
			g.circle("fill", ball.x, ball.y, ball.r, 32)
--			g.line(ball.x, ball.y, ball.x+ball.ax, ball.y+ball.ay)
		end
	end
end

function level.keypressed(key)
	if key == "g" then
		grid_visible = not grid_visible
	end
end

return level
