if type(APP.model) ~= "table" then
    APP.model = {}
end

APP.model = util.merge_tables(APP.model, { testBase2 = true })