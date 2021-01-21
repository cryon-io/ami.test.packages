local _json = ...

local _info = {
    level = "ok",
    status = "success",
    version = am.app.get_version(),
    type = am.app.get_type()
}

if _json then
    print(hjson.stringify_to_json(_info, {indent = false}))
else
    print(hjson.stringify(_info))
end