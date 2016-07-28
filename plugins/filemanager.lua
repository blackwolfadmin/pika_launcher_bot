local function callback_save_a(msg, success, result)
	local file = admin_dir..fnamefsave
	os.rename(result, file)
	return send_large_msg(chat_id, 'فایل ذخیره شد')
end

local function get_message_callback_save_a(extra, success, result)
	if result.media then
		load_document(result.id, callback_save_a, result)
	else
		local text = result.text
		local file = io.open(admin_dir..fnamefsave, "w")
		file:write(text)
		file:flush()
		file:close() 
		return send_large_msg(chat_id, 'فایل متنی ذخیره شد')
	end
end

local function callback_save_s(msg, success, result)
	local file = "./"..fnamefsave
	os.rename(result, file)
	return send_large_msg(chat_id, 'فایل ذخیره شد')
end

local function get_message_callback_save_s(extra, success, result)
	if result.media then
		load_document(result.id, callback_save_s, result)
	else
		local text = result.text
		local file = io.open("./"..fnamefsave, "w")
		file:write(text)
		file:flush()
		file:close() 
		return send_large_msg(chat_id, 'فایل متنی ذخیره شد')
	end
end

local function callback_view(msg, success, result)
	local file = io.open(result, "r")
	local text = file:read("*all")
	return send_large_msg(chat_id, text)
end

local function get_message_callback_view(extra, success, result)
	if result.media then
		if result.media.type == 'document' then
			load_document(result.id, callback_view, result)
		else
			return send_large_msg(chat_id, 'مورد انتخاب شده شامل متن نیست')
		end
	else
		return send_large_msg(chat_id, 'مورد انتخاب شده فایل نیست')
	end
end

local function run(msg, matches)
    chat_id = "chat#id"..msg.to.id
	user_id = "user#id"..msg.from.id
	admin_dir = "./adminfiles/"..msg.from.id.."/_"
	
	if matches [1] == "$" and is_sudo(msg) then
		return io.popen(matches[2]):read('*all')
		
	elseif matches [1] == "dir" and is_admin(msg) then
		local dirfiles = io.popen('ls -F ./adminfiles/'..msg.from.id):read('*all')
		return 'لیست فایلهای شما:\n______________________________\n'..string.gsub(dirfiles, '_', '')
	
	elseif matches [1] == "del" and is_admin(msg) then
		local rmfile = io.popen('rm '..admin_dir..matches[2]):read('*all')
		return 'فایل مورد نظر پاک شد'
	
	elseif matches[1] == "getplug" and is_sudo(msg) then
		if #matches == 3 then
			local file = io.open("./plugins/"..matches[3]..".lua", "r")
			if file ~= nil then
				send_document(user_id,"./plugins/"..matches[3]..".lua", ok_cb, false)
				return 'در خصوصی ارسال شد'
			else
				return 'پلاگین موجود نیست'
			end
		else
			local file = io.open("./plugins/"..matches[2]..".lua", "r")
			if file ~= nil then
				return send_document(chat_id,"./plugins/"..matches[2]..".lua", ok_cb, false)
			else
				return 'پلاگین موجود نیست'
			end
		end

	elseif matches[1] == "setplug" and is_sudo(msg) then
		local text = string.sub(matches[3], 1, 10000000000)
		local file = io.open("./plugins/"..matches[2]..".lua", "w")
		file:write(text)
		file:flush()
		file:close() 
		return "ابزار ذخيره شد"

	elseif matches[1] == "get" and is_admin(msg) then
		if #matches == 3 then
			local file = download_to_file(matches[2])
			os.rename(file, "./file/download."..matches[3])
			local file = "./file/download."..matches[3]
			local mime_type = mimetype.get_content_type_no_sub(matches[3])
			if mime_type == 'image' then
				send_photo(chat_id, file, ok_cb, false)
			else
				send_document(chat_id, file, ok_cb, false)
			end
		else
			if is_sudo(msg) then
				local file = io.open("./"..matches[2], "r")
				if file ~= nil then
					send_document(user_id, "./"..matches[2], ok_cb, false)
					return 'در خصوصی ارسال شد'
				else
					return 'فایل موجود نیست'
				end
			elseif is_admin(msg) then
				local file = io.open(admin_dir..matches[2], "r")
				if file ~= nil then
					send_document(user_id, admin_dir..matches[2], ok_cb, false)
					return 'در خصوصی ارسال شد'
				else
					return 'فایل موجود نیست یا برای شما نمیباشد'
				end
			end
		end
		
	elseif matches[1] == "get>" and is_admin(msg) then
		if is_sudo(msg) then
			local file = io.open("./"..matches[2], "r")
			if file ~= nil then
				send_document(chat_id, "./"..matches[2], ok_cb, false)
			else
				return 'فایل موجود نیست'
			end
		elseif is_admin(msg) then
			local file = io.open(admin_dir..matches[2], "r")
			if file ~= nil then
				send_document(chat_id, admin_dir..matches[2], ok_cb, false)
			else
				return 'فایل موجود نیست یا برای شما نمیباشد'
			end
		end
		
	elseif matches[1] == "view" and is_admin(msg) then
		if msg.reply_id then
			return get_message(msg.reply_id, get_message_callback_view, false)
		end
		if #matches == 3 then
			local file = http.request(matches[2])
			local mime_type = mimetype.get_content_type_no_sub(matches[3])
			if mime_type == 'text' then
				return file
			elseif matches[3] == 'htm' then
				return file
			elseif matches[3] == 'html' then
				return file
			elseif matches[3] == 'php' then
				return file
			elseif matches[3] == 'js' then
				return file
			elseif matches[3] == 'aspx' then
				return file
			elseif matches[3] == 'css' then
				return file
			else
				return 'لینک فایل وارد شده شامل متن نمیباشد'
			end
		else
			if is_sudo(msg) then
				local file = io.open("./"..matches[2], "r")
				if file ~= nil then
					local text = file:read("*all")
					send_large_msg(user_id, text)
					return 'در خصوصی ارسال شد'
				else
					return 'فایل موجود نیست'
				end
			elseif is_admin(msg) then
				local file = io.open(admin_dir..matches[2], "r")
				if file ~= nil then
					local text = file:read("*all")
					send_large_msg(user_id, text)
					return 'در خصوصی ارسال شد'
				else
					return 'فایل موجود نیست یا برای شما نمیباشد'
				end
			end
		end
		
	elseif matches[1] == "save" and is_admin(msg) then
		if is_sudo(msg) then
			if msg.reply_id then
				if #matches == 1 then
					return 'نام و پسوند فایل را جهت ذخیره مشخص کنید'
				else
					fnamefsave = matches[2]
					return get_message(msg.reply_id, get_message_callback_save_s, false)
				end
			end
			if #matches == 4 then
				local file = download_to_file(matches[3])
				os.rename(file, "./"..matches[2]..'.'..matches[4])
				return 'فایل مورد نظر با نام '..matches[2]..'.'..matches[4]..' ذخیره شد'
			else
				local text = string.sub(matches[3], 1, 10000000000)
				local file = io.open("./"..matches[2], "w")
				file:write(text)
				file:flush()
				file:close() 
				return "فايل ذخيره شد"
			end
		else
			local file = io.open("./adminfiles/"..msg.from.id.."/Umbrella", "r")
			if file ~= nil then
				if msg.reply_id then
					if #matches == 1 then
						return 'نام و پسوند فایل را جهت ذخیره مشخص کنید'
					else
						fnamefsave = matches[2]
						return get_message(msg.reply_id, get_message_callback_save_a, false)
					end
				end
				if #matches == 4 then
					local file = download_to_file(matches[3])
					os.rename(file, admin_dir..matches[2]..'.'..matches[4])
					return 'فایل مورد نظر با نام '..matches[2]..'.'..matches[4]..' در هاست شما ذخیره شد'
				else
					local text = string.sub(matches[3], 1, 10000000000)
					local file = io.open(admin_dir..matches[2], "w")
					file:write(text)
					file:flush()
					file:close() 
					return "فايل ذخيره شد"
				end
			else
				local mkdir = io.popen('mkdir ./adminfiles/'..msg.from.id):read('*all')
				local file = io.open("./adminfiles/"..msg.from.id.."/Umbrella", "w")
				file:write(msg.from.id)
				file:flush()
				file:close()
				if msg.reply_id then
					if #matches == 1 then
						return 'نام و پسوند فایل را جهت ذخیره مشخص کنید'
					else
						fnamefsave = matches[2]
						return get_message(msg.reply_id, get_message_callback_save_a, false)
					end
				end
				if #matches == 4 then
					local file = download_to_file(matches[3])
					os.rename(file, admin_dir..matches[2]..'.'..matches[4])
					return 'فایل مورد نظر با نام '..matches[2]..'.'..matches[4]..' در هاست شما ذخیره شد'
				else
					local text = string.sub(matches[3], 1, 10000000000)
					local file = io.open(admin_dir..matches[2], "w")
					file:write(text)
					file:flush()
					file:close() 
					return "فايل ذخيره شد"
				end
			end
		end
	end
end

return {
	description = "File Manager", 
	usagehtm = '<tr><td align="center">/save متن نام.پسوند</td><td align="right">این پلاگین مربوط به ادمینها و سودو است و یکصد گیگابایت فضا در اختیارشان قرار میدهد. با این دستور میتوانند در فضایشان فایل متنی با پسوند دلخواه درست کنند</td></tr>'
	..'<tr><td align="center">/save لینک نام</td><td align="right">با این دستور قادرند در فضایشان یک فایل را از لینکی دانلود و با نام دلخواه ذخیره کنند</td></tr>'
	..'<tr><td align="center">/save نام.پسوند</td><td align="right">با رپلی کردن این دستور میتوانند هر فایلی را ائم از فیلم موسیقی عکس استیکر متن و هر فایل دیگر را در فضای خود ذخیره کنند همچنین این دستور اگر روی پیام های متنی نیز رپلی شود به صورت فایل تکست ذخیره خواهند شد</td></tr>'
	..'<tr><td align="center">/get نام و پسوند</td><td align="right">بدین وسیله میتوانید فایلهای ذخیره شده را در خصوصی دریافت نمایید، دقت کنید که هر شخص فقط میتواند فایلهای خود را دریافت نماید</td></tr>'
	..'<tr><td align="center">/get> نام و پسوند</td><td align="right">بدین وسیله میتوانید فایلهای ذخیره شده را در گروه دریافت نمایید، دقت کنید که هر شخص فقط میتواند فایلهای خود را دریافت نماید</td></tr>'
	..'<tr><td align="center">/get لینک</td><td align="right">با این دستور میشود فایلها را از لینکها دانلود کرد و در گروه نمایش داد</td></tr>'
	..'<tr><td align="center">/dir</td><td align="right">لیست فایل های شخص را نشان میدهد</td></tr>'
	..'<tr><td align="center">/del نام.پسوند</td><td align="right">فایل مورد نظر را از فضایتان حذف میکند</td></tr>'
	..'<tr><td align="center">/view نام.پسوند</td><td align="right">فایل متنی مورد نظرتان که در فضای شما موجو است، به صورت یک پیام نمایش میدهد</td></tr>'
	..'<tr><td align="center">/view لینک</td><td align="right">سورس صفحات اینترنتی با زبان اچ تی ام ال، پی اچ پی، جاوا، اجاکس، ای اس پی ایکس و... را نشان میدهد</td></tr>'
	..'<tr><td align="center">/view</td><td align="right">اگر این دستور با یک فایل متنی رپلی شود آن فایل به صورت پیام نمایش داده میشود</td></tr>'
	..'<tr><td align="center">/setplug متن نام</td><td align="right">افزودن یک پلاگین جدید به ربات</td></tr>'
	..'<tr><td align="center">/getplug نام</td><td align="right">دریافت پلاگینی ار ربات</td></tr>'
	..'<tr><td align="center">$دستور</td><td align="right">ارسال دستور به ترمینال و کنترل سرور</td></tr>',
	usage = {
	admin = {
		"/save (name) (txt|url|reply) : ذخیره",
		"/get (name|url) : دانلود",
		"/view (name|url|reply) : نمایش متن",
		"/dir : مشاهده فایلها",
		"/del (name) : حذف فایل",
	},
	sudo = {
		"/setfile (dir/name.ext) (txt) : ساخت فايل",
		"/getfile (dir/name.ext) : دانلود فايل",
		"$(command) : اعمال دستورات در ترمینال",
	},
	},
	patterns = {
		"^/(dir)$",
		"^/(del) (.*)$",
		"^/(save) ([^%s]+) (http?://[%w-_%.%?%.:/%+=&]+%.(.*))$",
		"^/(save) ([^%s]+) (.+)$",
		"^/(save) ([^%s]+)$",
		"^/(save)$",
		"^/(get) (http?://[%w-_%.%?%.:/%+=&]+%.(.*))$",
		"^/(get>) (.+)$",
		"^/(get) (.+)$",
		"^/(view) (http?://[%w-_%.%?%.:/%+=&]+%.(.*))$",
		"^/(view) (.+)$",
		"^/(view)$",
		"^/(getplug) (pv) (.+)$",
		"^/(getplug) (.+)$",
		"^/(setplug) ([^%s]+) (.+)$",
		"^($)(.*)$",
		"%[(document)%]",
		"%[(photo)%]",
		"%[(video)%]",
		"%[(audio)%]",
    }, 
	run = run,
}