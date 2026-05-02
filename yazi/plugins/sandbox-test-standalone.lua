#!/usr/bin/env lua
-- Standalone Lua sandbox test
-- Tests io.popen() without yazi's runtime to isolate the issue
-- Run: lua /home/flak/.config/yazi/plugins/sandbox-test-standalone.lua

print("=== Lua Sandbox Test ===")
print("Lua version: " .. _VERSION)
print()

-- TEST 1: io.popen with simple echo
print("TEST 1: io.popen('echo HELLO_WORLD')")
local f = io.popen("echo HELLO_WORLD", "r")
if f then
  local result = f:read("*a")
  f:close()
  print("  PASS: Got output: " .. result:gsub("\n", ""))
else
  print("  FAIL: io.popen returned nil")
end

-- TEST 2: io.popen with chafa
print()
print("TEST 2: io.popen('which chafa')")
local f = io.popen("which chafa", "r")
if f then
  local path = f:read("*l")
  f:close()
  print("  chafa found at: " .. tostring(path))
else
  print("  FAIL: which chafa returned nil")
end

-- TEST 3: io.popen with chafa on actual file
print()
print("TEST 3: io.popen('chafa --size 80x24 --symbols half --stretch /home/flak/Pictures/2023-10-05T08:51:30,580919070+09:00.png')")
local f = io.popen("chafa --size 80x24 --symbols half --stretch '/home/flak/Pictures/2023-10-05T08:51:30,580919070+09:00.png'", "r")
if f then
  local result = f:read("*a")
  f:close()
  print("  PASS: Got " .. #result .. " bytes of output")
  print("  First 200 chars:")
  print(result:sub(1, 200))
else
  print("  FAIL: chafa io.popen returned nil")
end

-- TEST 4: io.stderr
print()
print("TEST 4: io.stderr:write()")
io.stderr:write("STDERR TEST: This is written to stderr\n")

print()
print("=== Standalone test complete ===")
