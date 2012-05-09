local Ball = {}
Ball.__index = Ball

local function new(x, y, velx, vely, r, m)
	local ball = {}

	x = x or 100
	y = y or 100
	r = r or 10

	ball.x = x
	ball.y = y
	ball.velx = velx or 0
	ball.vely = vely or 0
	ball.r = r
	ball.m = m or 400
	ball.pole = 0
	ball.ax = 0
	ball.ay = 0

	ball.phys = {}
	ball.phys.b = love.physics.newBody(game.world, x, y, 'dynamic')
	ball.phys.b:setMass(10)
	ball.phys.s = love.physics.newCircleShape(r)
	ball.phys.f = love.physics.newFixture(ball.phys.b, ball.phys.s)
	ball.phys.f:setFriction(0)
	ball.phys.f:setRestitution(1)
	ball.phys.f:setUserData({ball=ball})
--	ball.phys.b:applyLinearImpulse(230, 230)

	return setmetatable(ball, Ball)
end

function Ball:destroy()
	self.phys.b:destroy()
end

function Ball:getPosition()
	return self:getX(), self:getY()
end

function Ball:getX()
	return self.phys.b:getX()
end

function Ball:getY()
	return self.phys.b:getY()
end

return setmetatable({new=new}, {__call=function(_, ...) return new(...) end})
