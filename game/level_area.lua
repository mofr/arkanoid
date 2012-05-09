local Area = {}
Area.__index = Area

local function new(left, top, right, bottom)
	local area = {}
	area.left = left
	area.top = top
	area.right = right
	area.bottom = bottom

	area.w = right-left
	area.h = bottom-top

	area.outline = {}
	outline = area.outline
	outline.b = love.physics.newBody(game.world, 0, 0, 'static')
	outline.s = love.physics.newChainShape(true, left,top, right,top, right,bottom, left,bottom)
	outline.f = love.physics.newFixture(outline.b, outline.s)
	outline.f:setFriction(0)
	outline.f:setRestitution(1)

	return setmetatable(area, Area)
end

function Area:debugDraw()
	g.setColor(255,255,255)
	g.line(self.outline.b:getWorldPoints(self.outline.s:getPoints()))
end

return setmetatable({new=new}, {__call = function(_, ...) return new(...) end})
