local M = {}

function M:peek(job)
  local file = job.file
  if not file then return end
  
  -- Use ya.dbg() to log to yazi.log
  ya.dbg("TEST PREVIEW: " .. tostring(file.url))
end

function M:seek(job)
end

return M
