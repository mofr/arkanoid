local Paddle = {}
Paddle.__index = Paddle

function build_shape(w, x, y, phi)
	local shape = {}
	table.insert(shape, 0)
	table.insert(shape, 0)
	table.insert(shape, w)
	table.insert(shape, 0)

	if phi <= 0 then
		--rectangle shape
		table.insert(shape, w)
		table.insert(shape, -y)
		table.insert(shape, 0)
		table.insert(shape, -y)
		return shape
	end

	local points = 16
	local r = w/2/math.sin(phi/2)
	y = y - (r^2-w^2/4)^0.5
	local step = phi/(points-1)
	local ang = (math.pi-phi)/2

	for i=1,points do
		local p = Vector(r, 0):rotated(ang)
		table.insert(shape, p.x+x)
		table.insert(shape, -p.y-y)
		ang = ang + step
	end

	return shape
end

local function createPhysics(paddle)
	local phys = {}
	phys.b = love.physics.newBody(game.world, paddle.x, paddle.y, 'static')
	phys.s = love.physics.newChainShape(true, unpack(build_shape(paddle.w,paddle.w/2,paddle.h/2, paddle.phi)) )

	phys.f = love.physics.newFixture(phys.b, phys.s)
	phys.f:setFriction(0)
	phys.f:setRestitution(1)
	phys.f:setUserData({'paddle', paddle})

	return phys
end

local function new()
	local paddle = {}

	local x = game.level.area.w/2
	local y = game.level.area.bottom
	local w = 100
	local h = 24

	paddle.x = x
	paddle.y = y
	paddle.w = w
	paddle.h = h
	paddle.pole = 0
	paddle.m = 800
	paddle.phi = math.pi/2

	paddle.phys = createPhysics(paddle)

	return setmetatable(paddle, Paddle)
end

local function updateShape(self)
	self:destroy()
	self.phys = createPhysics(self)
end

function Paddle:destroy()
	self.phys.b:destroy()
end

function Paddle:setShapeAngle(phi)
	self.phi = math.clamp(phi, 0, math.pi*2/3)
	updateShape(self)
end

function Paddle:setWidth(w)
	self.w = math.max(w, 10)
	updateShape(self)
end

function Paddle:getPosition()
	return self:getX(), self:getY()
end

function Paddle:getSize()
	return self:getWidth(), self:getHeight()
end

function Paddle:getX()
	return self.x
end

function Paddle:getY()
	return self.y
end

function Paddle:getWidth()
	return self.w
end

function Paddle:getHeight()
	return self.h
end

function Paddle:getShapeAngle()
	return self.phi
end

function Paddle:moveTo(x)
	self.x = x-self.w/2
	if self.x < game.level.area.left then self.x = game.level.area.left end
	if self.x > game.level.area.right-self.w then self.x = game.level.area.right-self.w end
	self.phys.b:setPosition(self.x, self.y)
end

function Paddle:debugDraw()
	if self.pole == 1 then
		g.setColor(255, 0, 0)
	elseif self.pole == -1 then
		g.setColor(0, 0, 255)
	else
		g.setColor(255, 255, 255)
	end
	g.polygon('fill', self.phys.b:getWorldPoints(self.phys.s:getPoints()))
end

function Paddle:draw()
	self:debugDraw()
end

return setmetatable({new=new}, {__call=function(_, ...) return new(...) end})
