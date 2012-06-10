local Floor = {}
Floor.__index = Floor

local function new(w, h)
	local self = {}
	self.w = w
	self.h = h

	self.phys = {}
	phys = self.phys
	phys.b = love.physics.newBody(game.world, 0, 0, 'static')
	phys.s = love.physics.newEdgeShape(0,h, w,h)
	phys.f = love.physics.newFixture(phys.b, phys.s)
	phys.f:setFriction(0)
	phys.f:setRestitution(1)
	phys.f:setUserData({'floor', self})

	return setmetatable(self, Floor)
end

function Floor:debugDraw()
	g.setColor(255,55,55, 80)
	g.line(self.phys.b:getWorldPoints(self.phys.s:getPoints()))
end

function Floor:draw()
	self:debugDraw()
end

return setmetatable({new=new}, {__call = function(_, ...) return new(...) end})
