local get_cwd = ya.sync(function()
	local cwd = cx.active.current.cwd
	return tostring(cwd)
end)

return {
	entry = function()
		local cwd = get_cwd()
		local output, err = Command("git-pull-full"):cwd(cwd):env("PATH", os.getenv("PATH")):output()

		local msg = ""
		local level = "info"

		if output then
			msg = (output.stdout or "") .. (output.stderr or "")
			if msg == "" then
				msg = "Done (no output)"
			end
			if output.status and output.status.code ~= 0 then
				level = "error"
			end
		else
			msg = "Error: " .. tostring(err)
			level = "error"
		end

		ya.notify({
			title = "Git Pull Full",
			content = msg,
			timeout = 5,
			level = level,
		})
	end,
}
