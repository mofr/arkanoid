local ball = {}
ball.__index = ball

local function new(x, y, velx, vely, r, m)
	local obj = {}

	x = x or 100
	y = y or 100
	r = r or 10

	obj.x = x
	obj.y = y
	obj.velx = velx or 0
	obj.vely = vely or 0
	obj.r = r
	obj.m = m or 400
	obj.pole = 0
	obj.ax = 0
	obj.ay = 0

	obj.phys = {}
	obj.phys.b = love.physics.newBody(game.world, x, y, 'dynamic')
	obj.phys.b:setMass(10)
	obj.phys.s = love.physics.newCircleShape(r)
	obj.phys.f = love.physics.newFixture(obj.phys.b, obj.phys.s)
	obj.phys.f:setFriction(0)
	obj.phys.f:setRestitution(1)
	obj.phys.f:setUserData({ball=obj})
--	obj.phys.b:applyLinearImpulse(230, 230)

	setmetatable(obj, ball)
	obj:getPosition()
	return obj
end

function ball:destroy()
	self.phys.b:destroy()
end

function ball:getPosition()
	return self:getX(), self:getY()
end

function ball:getX()
	return self.phys.b:getX()
end

function ball:getY()
	return self.phys.b:getY()
end

return {new=new}
