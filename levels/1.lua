local level = game.level.new()

function level.enter()
	local b = BlockBuilder{size={120, 80}, spacing=3, margin={100,0,0,0}}

	local w = 4
	local x = (b:width()-w)/2

	b:moveTo( x, 0 )
	b:lineX( x+w )

	b:moveTo( x, 2 )
	b:lineX( x+w )
end

return level
