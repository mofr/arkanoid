function LevelGrid(grid)
	local cells = grid[1]

	local countX, countY = 0, 0
	local rows = {}
	for row in string.gmatch(cells, '[^%s]+') do
		table.insert(rows, row)
		countY = countY + 1
		local rowLen = string.len(row)
		if rowLen > countX then countX = rowLen end
	end

	local stepX = grid.cellSize[1] + grid.spacing
	local stepY = grid.cellSize[2] + grid.spacing
	local w = stepX * countX + grid.spacing
	local h = stepY * countY + grid.spacing

	game.level.setSize(w)

	local cellRect = {}
	cellRect.x = grid.spacing
	cellRect.y = grid.spacing
	cellRect.w = grid.cellSize[1]
	cellRect.h = grid.cellSize[2]
	for _, row in ipairs(rows) do
		cellRect.x = grid.spacing
		for cell in string.gmatch(row, '[^%s]') do
			if grid[cell] then
				grid[cell](cellRect)
			end
			cellRect.x = cellRect.x + stepX
		end
		cellRect.y = cellRect.y + stepY
	end
end
