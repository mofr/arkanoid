local Area = {}
Area.__index = Area

local function createPhysics(self)
	local phys = {}

	phys.b = love.physics.newBody(game.world, 0, 0, 'static')
	phys.s = love.physics.newChainShape(true, 0,0, self.w,0, self.w,self.h, 0,self.h)
	phys.f = love.physics.newFixture(phys.b, phys.s)
	phys.f:setFriction(0)
	phys.f:setRestitution(1)
	phys.f:setUserData({'bounds', self})

	return phys
end

local function new(w, h)
	local self = {}
	self.w = w
	self.h = h

	self.phys = createPhysics(self)

	return setmetatable(self, Area)
end

function Area:destroy()
	self.phys.b:destroy()
end

function Area:debugDraw()
	g.setColor(255,255,255)
	g.line(self.phys.b:getWorldPoints(self.phys.s:getPoints()))
end

function Area:draw()
	self:debugDraw()
end

return setmetatable({new=new}, {__call = function(_, ...) return new(...) end})
