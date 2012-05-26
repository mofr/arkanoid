local EntityList = {}
EntityList.__index = EntityList

local function new(proto)
	local list = {proto=proto, entities={}}
	return setmetatable(list, EntityList)
end

function EntityList:new(...)
	assert(self.proto, "You cannot use this function without proto (pass in constructor)")
	
	local entity = self.proto(...)
	table.insert(self.entities, entity)
	return entity
end

function EntityList:add(entity)
	table.insert(self.entities, entity)
end

function EntityList:update(dt)
	local entity
	for i = #self.entities, 1, -1 do
		entity = self.entities[i]
		if entity.dead then
			if entity.destroy then entity:destroy() end
			table.remove(self.entities, i)
		else
			entity:update(dt)
		end
	end
end

--[[ through __index
function EntityList:draw()
	for entity in self() do
		entity:draw()
	end
end
--]]

function EntityList:clear()
	for entity in self() do
		entity:destroy()
	end
	self.entities = {}
end

function EntityList:count()
	return #self.entities
end

--iterator
function EntityList:__call()
	local i = 0
	local n = #self.entities
	return function ()
		i = i + 1
		if i <= n then return self.entities[i] end
	end
end

--forward foreach
function EntityList:__index(key)
	if EntityList[key] ~= nil then return EntityList[key] end

	return function(...)
		for entity in self() do
			entity[key](entity, ...)
		end
	end
end

return setmetatable({},{__call=function(_, ...) return new(...) end})
