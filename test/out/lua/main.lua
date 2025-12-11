local M = {}


M.hello = "Hello"
M.world = "World!"

M.hello_world = M.hello + " " + M.world


function M.main()
	stdio.printf("%s\n", M.hello_world)
	return 0
end


return M


