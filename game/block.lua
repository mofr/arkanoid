local Block = {}
Block.__index = Block

local function new(x, y, w, h)
	local block = {}

	block.x = x
	block.y = y
	block.w = w
	block.h = h

	block.phys = {}
	block.phys.b = love.physics.newBody(game.world, x+w/2, y+h/2, 'static')
	block.phys.s = love.physics.newRectangleShape(w, h)
	block.phys.f = love.physics.newFixture(block.phys.b, block.phys.s)
	block.phys.f:setFriction(0)
	block.phys.f:setRestitution(1)
	block.phys.f:setUserData({block=block})

	return setmetatable(block, Block)
end

function Block:destroy()
	self.phys.b:destroy()
end

function Block:getPosition()
	return self:getX(), self:getY()
end

function Block:getSize()
	return self:getWidth(), self:getHeight()
end

function Block:getX()
	return self.x
end

function Block:getY()
	return self.y
end

function Block:getWidth()
	return self.w
end

function Block:getHeight()
	return self.h
end

return setmetatable({new=new}, {__call=function(_, ...) return new(...) end})
