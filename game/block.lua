local block = {}
block.__index = block

local function new(x, y, w, h)
	local obj = {}

	obj.x = x
	obj.y = y
	obj.w = w
	obj.h = h

	obj.phys = {}
	obj.phys.b = love.physics.newBody(game.world, x+w/2, y+h/2, 'static')
	obj.phys.s = love.physics.newRectangleShape(w, h)
	obj.phys.f = love.physics.newFixture(obj.phys.b, obj.phys.s)
	obj.phys.f:setFriction(0)
	obj.phys.f:setRestitution(1)
	obj.phys.f:setUserData({block=obj})

	setmetatable(obj, block)
	obj:getPosition()
	return obj
end

function block:destroy()
	self.phys.b:destroy()
end

function block:getPosition()
	return self:getX(), self:getY()
end

function block:getSize()
	return self:getWidth(), self:getHeight()
end

function block:getX()
	return self.x
end

function block:getY()
	return self.y
end

function block:getWidth()
	return self.w
end

function block:getHeight()
	return self.h
end

return {new=new}
