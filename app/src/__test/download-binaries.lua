local _ok, _error = fs.safe_mkdirp("bin")
ami_assert(_ok, string.join_strings("Failed to prepare bin dir: ", _error))

local _value = am.app.get_model("testApp")
local _ok = fs.safe_write_file("bin/test.bin", tostring(_value))
ami_assert(_ok, "Failed to write test file: " .. (_error or ""))