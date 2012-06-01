local Detector = {}
Detector.__index = Detector

local signals = Signals()

local function endContact(a, b, c)
	local d1 = a:getUserData()
	local d2 = b:getUserData()

	--emit signal
	if d1 and d2 then
		-- 'ball','block' and 'block','ball' should work
		signals:emit(d1[1]..d2[1], d1[2], d2[2])
		signals:emit(d2[1]..d1[1], d2[2], d1[2])
	end
end

function Detector:reset()
	game.world:setCallbacks(nil, endContact, nil, nil)
	signals:clear()
end

function Detector:registerCallback(a, b, func)
	signals:register( a..b, func )
end

return setmetatable({}, Detector)
