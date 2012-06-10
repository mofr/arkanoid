local blockHits = 0
local boundsHits = 0
local samples = 0

local function resetHits()
	blockHits = 0
	boundsHits = 0
end

local function updateEffectiveness()
	local current = blockHits / ( 1.0+boundsHits*0.1 )
	game.player.effectiveness = (game.player.effectiveness*samples + current) / (samples+1)
	resetHits()
	samples = samples + 1
end

local function reset()
	resetHits()
	samples = 0
	game.player.effectiveness = 0

	game.collider:registerCallback('ball', 'block', function(ball, block)
		blockHits = blockHits + 1
	end)

	game.collider:registerCallback('ball', 'bounds', function(ball, bounds)
		boundsHits = boundsHits + 1
	end)

	game.collider:registerCallback('ball', 'paddle', function(ball, paddle)
		updateEffectiveness()
	end)

	game.collider:registerCallback('ball', 'floor', function(ball, paddle)
		updateEffectiveness()
	end)
end

local function update(dt)
end

return {
	reset = reset,
	update = update
}