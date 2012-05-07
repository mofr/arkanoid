function love.conf(t)
	t.title = "mofr arkanoid"
	t.author = "mofr"
	t.identity = "mofr_arkanoid"
	t.console = false
	t.screen.fsaa = 4
	t.screen.width = 1024
	t.screen.height = 768
	t.screen.vsync = false
	t.screen.fullscreen = false
	t.modules.joystick = false
	t.modules.physics = true
end
