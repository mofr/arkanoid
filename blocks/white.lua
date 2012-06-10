local Block = {}
Block.__index = Block

local img = g.newImage('media/white.png')

local function new(args)
	local self = {}

	self.x = args.x
	self.y = args.y
	self.w = args.w
	self.h = args.h
	self.health = args.health or 1.0

	self.phys = {}
	self.phys.b = love.physics.newBody(game.world, self.x+self.w/2, self.y+self.h/2, 'static')
	self.phys.s = love.physics.newRectangleShape(self.w, self.h)
	self.phys.f = love.physics.newFixture(self.phys.b, self.phys.s)
	self.phys.f:setFriction(0)
	self.phys.f:setRestitution(1)
	self.phys.f:setUserData({'block', self})

	return setmetatable(self, Block)
end

function Block:destroy()
	self.phys.b:destroy()
end

function Block:damage(dmg)
	dmg = dmg or 1.0
	self.health = self.health - dmg
	if self.health <= 0.0 then self.dead = true end
end

function Block:update(dt)
end

function Block:draw()
	g.draw(img, self.x, self.y)
end

return setmetatable({new=new, size={img:getWidth(), img:getHeight()}}, {__call=function(_, ...) return new(...) end})
