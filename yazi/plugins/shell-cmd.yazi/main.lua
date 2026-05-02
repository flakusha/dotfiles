--- @sync peek
local get_cwd = ya.sync(function()
	return tostring(cx.active.current.cwd)
end)

return {
	entry = function(_, job)
		local args = job.args or {}
		local title = args[1] or "Shell"

		-- Everything after first arg is the command
		local parts = {}
		for i = 2, #args do
			parts[#parts + 1] = args[i]
		end
		local cmd = table.concat(parts, " ")

		if cmd == "" then
			ya.notify({
				title = "shell-cmd",
				content = "Usage: plugin shell-cmd -- Title cmd arg1 arg2",
				timeout = 5,
				level = "error",
			})
			return
			-- else
			-- 	ya.notify({
			-- 		title = "shell-cmd",
			-- 		content = cmd,
			-- 		timeout = 5,
			-- 		level = "info",
			-- 	})
		end

		local cwd = get_cwd()
		local path = os.getenv("PATH") or "/bin:/usr/local/bin:/usr/bin:/bin:/home/flak/.local/bin"
		local output, err = Command("bash"):arg({ "-c", cmd }):cwd(cwd):env("PATH", path):output()

		local msg = ""
		local level = "info"

		if output then
			msg = (output.stdout or "") .. (output.stderr or "")
			if msg == "" then
				msg = "Done ✅"
			end
			if output.status and output.status.code ~= 0 then
				level = "error"
			end
		else
			msg = "Error: " .. tostring(err)
			level = "error"
		end

		ya.notify({
			title = title,
			content = msg,
			timeout = 5,
			level = level,
		})
	end,
}
