-- Yazi Lua Sandbox Test Plugin
-- Tests: io.popen, ya.notify, ya.dbg, file access, term_size
--
-- USAGE:
-- 1. Hover over a PNG file in yazi
-- 2. Check for a notification (proves plugin is loaded and invoked)
-- 3. Check yazi.log for ya.dbg() output
-- 4. Check if terminal shows chafa output (proves io.popen works)

local M = {}

function M:peek(job)
  local file = job.file
  if not file then return end

  -- TEST 1: ya.notify() — if this shows, plugin is loaded and invoked
  ya.notify {
    title = "TEST: Plugin Loaded",
    content = "Plugin is working! File: " .. tostring(file.url),
    timeout = 5,
    level = "info",
  }

  -- TEST 2: ya.dbg() — check yazi.log for this
  -- Note: file.cha.is_dir (field), file.cha.len (size in bytes)
  local cha = file.cha
  ya.dbg("SANDBOX TEST: file.url=" .. tostring(file.url))
  ya.dbg("SANDBOX TEST: file.name=" .. tostring(file.name))
  ya.dbg("SANDBOX TEST: file.cha.is_dir=" .. tostring(cha and cha.is_dir))
  ya.dbg("SANDBOX TEST: file.cha.len=" .. tostring(cha and cha.len))

  -- TEST 3: io.popen("echo hello") — simplest possible shell test
  local echo = io.popen("echo HELLO_WORLD", "r")
  if echo then
    local result = echo:read("*a")
    echo:close()
    ya.dbg("SANDBOX TEST: io.popen echo=" .. tostring(result))
    if result and result:find("HELLO_WORLD") then
      ya.notify {
        title = "TEST: io.popen works!",
        content = "Shell command executed: " .. result:gsub("\n", ""),
        timeout = 5,
        level = "info",
      }
    else
      ya.notify {
        title = "TEST: io.popen ran but no match",
        content = "Got: " .. tostring(result),
        timeout = 5,
        level = "warn",
      }
    end
  else
    ya.notify {
      title = "TEST: io.popen FAILED",
      content = "Shell execution returned nil",
      timeout = 5,
      level = "error",
    }
    ya.dbg("SANDBOX TEST: io.popen returned nil")
  end

  -- TEST 4: chafa — if io.popen works, chafa should too
  local chafa_ok = false
  local chafa = io.popen("which chafa", "r")
  if chafa then
    local cpath = chafa:read("*l")
    chafa:close()
    ya.dbg("SANDBOX TEST: chafa at=" .. tostring(cpath))
    if cpath and cpath ~= "" then
      chafa_ok = true
      -- Run chafa on the file
      local size = cha and cha.len or 0
      if size <= 100 * 1024 * 1024 then
        local term_w, term_h = ya.term_size()
        local chafa_w = math.floor(term_w * 0.9)
        local chafa_h = math.floor(term_h * 0.85)
        local filepath = tostring(file.url)

        local cmd = string.format(
          "chafa --size %dx%d --symbols half --stretch --dither diffusion %q",
          chafa_w, chafa_h, filepath
        )
        ya.dbg("SANDBOX TEST: chafa cmd=" .. cmd)

        local out = io.popen(cmd, "r")
        if out then
          local output = out:read("*a")
          out:close()
          ya.dbg("SANDBOX TEST: chafa output_len=" .. #output)
          if output and #output > 0 then
            io.write(output)
            chafa_ok = true
          else
            ya.dbg("SANDBOX TEST: chafa returned empty output")
          end
        else
          ya.dbg("SANDBOX TEST: chafa io.popen returned nil")
        end
      else
        ya.dbg("SANDBOX TEST: file too large for chafa")
      end
    else
      ya.dbg("SANDBOX TEST: chafa not found")
    end
  else
    ya.dbg("SANDBOX TEST: which chafa failed")
  end

  -- TEST 5: term_size
  local tw, th = ya.term_size()
  ya.dbg("SANDBOX TEST: term_size=" .. tw .. "x" .. th)

  -- Final notification summarizing results
  if chafa_ok then
    ya.notify {
      title = "TEST: ALL PASSED",
      content = "Plugin loaded + io.popen works + chafa rendered!",
      timeout = 5,
      level = "info",
    }
  end
end

function M:seek(job)
end

return M
