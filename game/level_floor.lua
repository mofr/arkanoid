local Floor = {}
Floor.__index = Floor

local function new(height)
	local floor = {}
	floor.height = height

	floor.phys = {}
	phys = floor.phys
	phys.b = love.physics.newBody(game.world, 0, 0, 'static')
	phys.s = love.physics.newEdgeShape(0,height, g.getWidth(),height)
	phys.f = love.physics.newFixture(phys.b, phys.s)
	phys.f:setFriction(0)
	phys.f:setRestitution(1)
	phys.f:setUserData({floor=floor})

	return setmetatable(floor, Floor)
end

function Floor:debugDraw()
	g.setColor(255,55,55, 40)
	g.line(self.phys.b:getWorldPoints(self.phys.s:getPoints()))
end

return setmetatable({new=new}, {__call = function(_, ...) return new(...) end})
