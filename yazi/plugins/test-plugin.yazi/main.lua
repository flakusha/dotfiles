local M = {}
function M:peek(job)
  local file = job.file
  if not file then return end
  -- Test: write to stdout
  io.write("TEST: " .. tostring(file.url) .. "\n")
end
function M:seek(job)
end
return M
