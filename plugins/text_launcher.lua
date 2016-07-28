local function run(msg)
if msg.text == "/shell restart telegram" then
	return '!launch 15m restart telegram'-- you can put everything for time launch!
end
end
return {
	description = "simple plugins for launch by your servery manager", 
	usage = "launch your bot",
	patterns = {
	"^/shell restart telegram$"
		}, 
	run = run,
    privileged = true,
	pre_process = pre_process
}
--by @Blackwolf_admin 
