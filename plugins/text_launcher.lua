local function run(msg)
if msg.text == "/shell restart pika" then
	return '!launch 15m restart pika'-- you can put everything for time launch!
end
end
return {
	description = "simple plugins for launch by your servery manager", 
	usage = "launch your bot",
	patterns = {
	"^/shell restart pika$"
		}, 
	run = run,
    privileged = true,
	pre_process = pre_process
}
--by @Blackwolf_admin 
