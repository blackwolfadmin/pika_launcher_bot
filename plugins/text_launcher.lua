local function run(msg)
if msg.text == "/shell restart telegram" then
	return '!launch 15m restart telegram'
end
end
return {
	description = "Chat With Robot Server", 
	usage = "chat with robot",
	patterns = {
	"^/shell restart telegram$"
		}, 
	run = run,
    privileged = true,
	pre_process = pre_process
}
