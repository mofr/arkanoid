local Ball = {}
Ball.__index = Ball

local function new(args)
	local ball = {}

	ball.x = args.x
	ball.y = args.y
	ball.r = args.r or 10
	ball.m = args.m or 400
	ball.pole = args.pole or 0

	ball.phys = {}
	ball.phys.b = love.physics.newBody(game.world, ball.x, ball.y, 'dynamic')
	ball.phys.b:setMass(10)
	ball.phys.s = love.physics.newCircleShape(ball.r)
	ball.phys.f = love.physics.newFixture(ball.phys.b, ball.phys.s)
	ball.phys.f:setFriction(0)
	ball.phys.f:setRestitution(1)
	ball.phys.f:setUserData({ball=ball})

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

	if len > 1000 then
		v = v:normalized()*1000
		self.phys.b:setLinearVelocity(v:unpack())
--	else
--		v = v:clone()
--		if math.abs(v.x) < min_vel then v.x = min_vel*math.sign(v.x) end
--		if math.abs(v.y) < min_vel then v.y = min_vel*math.sign(v.y) end
--		ball.phys.b:setLinearVelocity(v:unpack())
	end
end

function Ball:draw()
	local x, y = self:getPosition()
		
	if self.ps then
		g.setBlendMode("additive")
		g.draw(self.ps, 0, 0)
	else
		if self.pole == 1 then
			g.setColor(255, 0, 0)
		elseif self.pole == -1 then
			g.setColor(0, 0, 255)
		else
			g.setColor(255, 255, 255)
		end
		g.circle("fill", x, y, self.r, 32)
	end
end

return setmetatable({new=new}, {__call=function(_, ...) return new(...) end})
