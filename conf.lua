
-- [Ice Project 2012, turtlesort.com]

function love.conf(t)
	t.title = "mofr arkanoid"
	t.author = "mofr"
	t.identity = "mofr_arkanoid"
	t.screen.fsaa = 4
	t.screen.width = 800
	t.screen.height = 600
	t.screen.vsync = false
	t.screen.fullscreen = true
	t.modules.joystick = false
	t.modules.physics = false
end