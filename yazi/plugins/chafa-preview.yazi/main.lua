-- Chafa image previewer for Yazi
-- Renders images as terminal-native ASCII art via chafa
-- This avoids ueberzug overhead in nested terminals (wezterm + zellij + yazi)

local M = {}

function M:peek(job)
  local file = job.file
  if not file or file:is_dir() then return end

  -- Debug: write to stderr to see if plugin is invoked
  io.stderr:write("DEBUG chafa-preview: file=" .. tostring(file.url) .. "\n")

  local size = file:size()
  if size and size > 100 * 1024 * 1024 then
    ya.notify {
      title = "Preview",
      content = ("Image too large (%s) — skipping"):format(ya.readable_size(size)),
      timeout = 3,
      level = "warn",
    }
    return
  end

  local term_w, term_h = ya.term_size()
  local chafa_w = math.floor(term_w * 0.9)
  local chafa_h = math.floor(term_h * 0.85)

  -- Try file.path first, fallback to tostring(file.url)
  local filepath = nil
  if file.path then
    filepath = tostring(file.path)
  end
  if not filepath or filepath == "" then
    filepath = tostring(file.url)
  end
  if not filepath or filepath == "" then return end

  io.stderr:write("DEBUG chafa-preview: path=" .. filepath .. "\n")

  local cmd = string.format(
    "chafa --size %dx%d --symbols half --stretch --dither diffusion %q",
    chafa_w, chafa_h, filepath
  )

  io.stderr:write("DEBUG chafa-preview: cmd=" .. cmd .. "\n")

  local stdout = io.popen(cmd, "r")
  if stdout then
    local output = stdout:read("*a")
    stdout:close()
    io.stderr:write("DEBUG chafa-preview: output_len=" .. tostring(#output) .. "\n")
    if output and #output > 0 then
      io.write(output)
    end
  else
    io.stderr:write("DEBUG chafa-preview: io.popen returned nil\n")
  end
end

function M:seek(job)
  -- No seeking needed for images
end

return M
