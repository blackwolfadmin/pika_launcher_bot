local filename='data/pika-launch.lua'
local cronned = load_from_file(filename)

local function save_cron(msg, text,date)
  local origin = get_receiver(msg)
  if not cronned[date] then
    cronned[date] = {}
  end
  local arr = { origin,  text } ;
  table.insert(cronned[date], arr)
  serialize_to_file(cronned, filename)
  return 'Saved!'
end

local function delete_cron(date)
  for k,v in pairs(cronned) do
    if k == date then
	  cronned[k]=nil
    end
  end
  serialize_to_file(cronned, filename)
end

local function cron()
  for date, values in pairs(cronned) do
  	if date < os.time() then --time's up
	  	send_msg(values[1][1], "/shell "..values[1][2], ok_cb, false)
  		delete_cron(date) --TODO: Maybe check for something else? Like user
	end

  end
end

local function actually_run(msg, delay,text)
  if (not delay or not text) then
  	return "Usage: !launch [delay: 2h3m1s] {launch text}"
  end
  save_cron(msg, text,delay)
  return "I'll launch your bot on " .. os.date("%x at %H:%M:%S",delay) .. " and repeat it by '/shell " .. text .. "'"
end

local function run(msg, matches)
  local sum = 0
  for i = 1, #matches-1 do
    local b,_ = string.gsub(matches[i],"[a-zA-Z]","")
    if string.find(matches[i], "s") then
      sum=sum+b
    end
    if string.find(matches[i], "m") then
      sum=sum+b*60
    end
    if string.find(matches[i], "h") then
      sum=sum+b*3600
    end
  end

  local date=sum+os.time()
  local text = matches[#matches]

  local text = actually_run(msg, date, text)
  return text
end

return {
  description = "launch plugin",
  usage = {
  	"!launch [delay: 2hms] text",
  	"!launch [delay: 2h3m] text",
  	"!launch [delay: 2h3m1s] text"
  },
  patterns = {
    "^[/#!]launch ([0-9]+[hmsdHMSD]) (.+)$",
    "^[/#!]launch ([0-9]+[hmsdHMSD])([0-9]+[hmsdHMSD]) (.+)$",
    "^[/#!]launch ([0-9]+[hmsdHMSD])([0-9]+[hmsdHMSD])([0-9]+[hmsdHMSD]) (.+)$"
  }, 
  run = run,
  privileged = true,
  cron = cron
}
--by @Blackwolf_admin 
