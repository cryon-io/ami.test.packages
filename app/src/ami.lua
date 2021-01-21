local _amiId = "TEST app"

return {
    title = _amiId,
    commands = {
        info = {
            description = "ami 'info' sub command",
            summary = "Prints runtime info and status of the app",
            action = function(_options, _, _, _cli)
                if _options.help then
                    am.print_help(_cli)
                    return
                end
                am.execute_extension("__test/info.lua", { contextFailExitCode = EXIT_APP_INFO_ERROR })
            end
        },
        setup = {
            options = {
                configure = {
                    description = "Configures application, renders templates and installs services"
                }
            },
            action = function(_options, _, _, _cli)
                if _options.help then
                    am.print_help(_cli)
                    return
                end
                local _noOptions = #util.keys(_options) == 0
                if _noOptions or _options.environment then
                    am.app.prepare()
                end

                if _noOptions or not _options["no-validate"] then
                    am.execute("validate", {"--platform"})
                end

                if _noOptions or not _options["no-validate"] then
                    am.execute("validate", {"--configuration"})
                end

                if _noOptions or _options.app then
                    am.execute_extension("__test/download-binaries.lua", { contextFailExitCode = EXIT_SETUP_ERROR })
                end

                if _noOptions or _options.configure then
                    am.app.render()

                    am.execute_extension("__test/configure.lua", { contextFailExitCode = EXIT_SETUP_ERROR })
                end
            end
        },
        start = {
            description = "ami 'start' sub command",
            summary = "Starts the TEST app",
            action = function(_options, _, _, _cli)
                if _options.help then
                    am.print_help(_cli)
                    return
                end
                am.execute_extension("__test/start.lua", { contextFailExitCode = EXIT_APP_START_ERROR })
            end
        },
        stop = {
            description = "ami 'stop' sub command",
            summary = "Stops the TEST app",
            action = function(_options, _, _, _cli)
                if _options.help then
                    am.print_help(_cli)
                    return
                end
                am.execute_extension("__test/stop.lua", { contextFailExitCode = EXIT_APP_STOP_ERROR })
            end
        },
        validate = {
            description = "ami 'validate' sub command",
            summary = "Validates app configuration and platform support",
            action = function(_options, _, _, _cli)
                if _options.help then
                    am.print_help(_cli)
                    return
                end
                -- //TODO: Validate platform
                -- //TODO: add switches
                ami_assert(proc.EPROC, "test app AMI requires extra api - eli.proc.extra", EXIT_MISSING_API)
                ami_assert(fs.EFS, "test app AMI requires extra api - eli.fs.extra", EXIT_MISSING_API)

                ami_assert(type(am.app.get("id")) == "string", "id not specified!", EXIT_INVALID_CONFIGURATION)
                ami_assert(
                    type(am.app.get_config()) == "table",
                    "configuration not found in app.h/json!",
                    EXIT_INVALID_CONFIGURATION
                )
                ami_assert(type(am.app.get("user")) == "string", "USER not specified!", EXIT_INVALID_CONFIGURATION)
                ami_assert(
                    type(am.app.get_type()) == "string",
                    "Invalid app type!",
                    EXIT_INVALID_CONFIGURATION
                )
                log_success("TEST app configuration validated.")
            end
        },
        about = {
            description = "ami 'about' sub command",
            summary = "Prints information about application",
            action = function(_options, _, _, _cli)
                if _options.help then
                    am.print_help(_cli)
                    return
                end

                local _ok, _aboutFile = fs.safe_read_file("__test/about.hjson")
                ami_assert(_ok, "Failed to read about file!", EXIT_APP_ABOUT_ERROR)
                local _hjson = require "hjson"
                local _ok, _about = pcall(_hjson.parse, _aboutFile)
                _about["App Type"] = type(APP.type) == "table" and APP.type.id or APP.type
                ami_assert(_ok, "Failed to parse about file!", EXIT_APP_ABOUT_ERROR)
                if am.options.OUTPUT_FORMAT == "json" then
                    print(_hjson.stringify_to_json(_about, {indent = false, skipkeys = true}))
                else
                    print(_hjson.stringify(_about))
                end
            end
        },
        customCmd = {
            index = 6,
            description = "test app 'removedb' command",
            summary = "Removes test app database",
            options = {
                help = HELP_OPTION
            },
            action = function(_options, _, _, _cli)
                if _options.help then
                    am.print_help(_cli)
                    return
                end
                am.execute_extension("__test/custom.lua", { contextFailExitCode = EXIT_APP_INTERNAL_ERROR })
                log_success("Succesfully executed custom command.")
            end
        },
        remove = {
            index = 7,
            action = function(_options, _, _, _cli)
                if _options.help then
                    am.print_help(_cli)
                    return
                end

                if _options.all then
                    am.app.remove()
                    log_success("Application removed.")
                else
                    am.app.remove_data()
                    log_success("Application data removed.")
                end
                return
            end
        }
    }
}
