local Builder = {}
Builder.__index = Builder

local alignment = {left = 0.0, top = 0.0, center = 0.5, right = 1.0, bottom = 1.0}

--args = {size={w px, h px}, spacing=spacing, margin={top, right, bottom, left}, align={horiz, vert}}
--vertical alignment = 'top', 'center', 'bottom'
--horizontal alignment = 'left', 'center', 'right'
local function new(args)
	local self = {}

	self.blockWidth = args.size[1]
	self.blockHeight = args.size[2]
	self.spacing = args.spacing
	self.margin = args.margin

	self.stepX = self.blockWidth+self.spacing
	self.stepY = self.blockHeight+self.spacing

	--metric - blocks
	local width = game.level.area.w - self.margin[4] - self.margin[2]
	local height = game.level.area.h - self.margin[1] - self.margin[3]
	self.w = math.floor(width/self.stepX)
	self.h = math.floor(height/self.stepY)

	--calculate shift from alignment
	args.align = args.align or {'center', 'center'}
	local shift = {0, 0}
	shift[1] = (width-self.spacing)%self.stepX * alignment[args.align[1]]
	shift[2] = (height-self.spacing)%self.stepY * alignment[args.align[2]]

	--set builder bounds
	self.top = game.level.area.top + self.margin[1] + shift[2]
	self.right = game.level.area.right - self.margin[2]
	self.bottom = game.level.area.bottom - self.margin[3]
	self.left = game.level.area.left + self.margin[4] + shift[1]

	--current draw coordinates
	self.x = 0
	self.y = 0

	return setmetatable(self, Builder)
end

function Builder:width()
	return self.w
end

function Builder:height()
	return self.h
end

function Builder:block(x, y)
	x = x*self.stepX + self.left
	y = y*self.stepY + self.top
	game.level.blocks:new(x, y, self.blockWidth, self.blockHeight)
end

function Builder:moveTo(x, y)
	self.x, self.y = x, y
end

function Builder:grid(w, h)
	local x, y
	for x = self.x, self.x+w-1 do
		for y = self.y, self.y+h-1 do
			self:block(x, y)
		end
	end
end

function Builder:rect(w, h)
	self:lineX(self.x+w)
	self:lineY(self.y+h)
	self:lineX(self.x-w)
	self:lineY(self.y-h)
end

function Builder:lineX(x)
	local delta = math.sign(self.x-x)
	if delta == 0 then return end
	for x=x+delta, self.x, delta do
		self:block(x, self.y)
	end
	self.x = x
end

function Builder:lineY(y)
	local delta = math.sign(self.y-y)
	if delta == 0 then return end
	for y=y+delta, self.y, delta do
		self:block(self.x, y)
	end
	self.y = y
end

return setmetatable({new=new}, {__call=function(_, ...) return new(...) end})
