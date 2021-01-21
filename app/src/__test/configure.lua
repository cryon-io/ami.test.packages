local _ok, _error = fs.safe_mkdirp("data/test")
ami_assert(_ok, "Failed to create test folder structure: " .. (_error or ""))
local _ok, _error = fs.safe_mkdirp("data/test2")
ami_assert(_ok, "Failed to create test folder structure: " .. (_error or ""))

local _value = am.app.get_model("testApp")
local _ok = fs.safe_write_file("data/test/test.file", tostring(_value))
ami_assert(_ok, "Failed to write test file: " .. (_error or ""))
local _ok = fs.safe_write_file("data/test2/test.file", tostring(_value))
ami_assert(_ok, "Failed to write test file: " .. (_error or ""))
