local Ball = {}
Ball.__index = Ball

local img = g.newImage('media/ball20.png')

local function new(args)
	local ball = {}

	ball.r = 10
	ball.m = args.m or 200
	ball.pole = args.pole or 0
	ball.max_vel = args.max_vel or 1000

	ball.phys = {}
	ball.phys.b = love.physics.newBody(game.world, args.x, args.y, 'dynamic')
	ball.phys.b:setMass(10)
	ball.phys.s = love.physics.newCircleShape(ball.r)
	ball.phys.f = love.physics.newFixture(ball.phys.b, ball.phys.s)
	ball.phys.f:setFriction(0)
	ball.phys.f:setRestitution(1)
	ball.phys.f:setUserData({'ball', ball})

	return setmetatable(ball, Ball)
end

function Ball:destroy()
	self.phys.b:destroy()
end

function Ball:enable()
	self.phys.b:setActive(true)
end

function Ball:disable()
	self.phys.b:setActive(false)
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

--local min_vel = 50
function Ball:update(dt)

	--limit minimum (to avoid non-bounce collisions) and maximum balls velocity
	local v = Vector(self.phys.b:getLinearVelocity())
	local len = v:len()

	if len > self.max_vel then
		v = v:normalized()*self.max_vel
		self.phys.b:setLinearVelocity(v:unpack())
--	else
--		v = v:clone()
--		if math.abs(v.x) < min_vel then v.x = min_vel*math.sign(v.x) end
--		if math.abs(v.y) < min_vel then v.y = min_vel*math.sign(v.y) end
--		ball.phys.b:setLinearVelocity(v:unpack())
	end
end

function Ball:draw()
	g.draw(img, self:getX()-self.r, self:getY()-self.r)
end

return setmetatable({new=new}, {__call=function(_, ...) return new(...) end})
