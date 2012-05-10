local Paddle = {}
Paddle.__index = Paddle

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
	paddle.m = 3000

	paddle.phys = {}
--	paddle.phys.b = love.physics.newBody(game.world, paddle.x+paddle.w/2, paddle.y-paddle.h/2, 'static')
--	paddle.phys.s = love.physics.newRectangleShape(paddle.w, paddle.h)
	paddle.phys.b = love.physics.newBody(game.world, x, y, 'static')
	paddle.phys.s = love.physics.newChainShape(true, 0,-h/2, 0,0, w,0, w,-h/2,  w*3/4,-h, w/4, -h)

	paddle.phys.f = love.physics.newFixture(paddle.phys.b, paddle.phys.s)
	paddle.phys.f:setFriction(0)
	paddle.phys.f:setRestitution(1)
	paddle.phys.f:setUserData({paddle=paddle})

	return setmetatable(paddle, Paddle)
end

function Paddle:destroy()
	self.phys.b:destroy()
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
--	g.rectangle("fill", self.x, self.y-self.h, self.w, self.h)
	g.polygon('fill', self.phys.b:getWorldPoints(self.phys.s:getPoints()))
end

return setmetatable({new=new}, {__call=function(_, ...) return new(...) end})
