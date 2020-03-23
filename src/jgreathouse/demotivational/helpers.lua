-- helper functions for accplimplishing tasks

local function new()
    local helpers = {}

    local function encode(str)
        return (str:gsub("([^A-Za-z0-9%_%.%-%~])", function(v)
                return string.upper(string.format("%%%02x", string.byte(v)))
        end))
    end

    -- for query values, prefer + instead of %20 for spaces
    local function encodeValue(str)
        local str = encode(str)
        return str:gsub('%%20', '+')
    end

    --- builds the querystring
    -- @param tab The key/value parameters
    -- @param sep The separator to use (optional)
    -- @param key The parent key if the value is multi-dimensional (optional)
    -- @return a string representing the built querystring
    function helpers.build_query(tab, sep, key)
        local query = {}
        if not sep then
            sep = '&'
        end
        local keys = {}
        for k in pairs(tab) do
            keys[#keys+1] = k
        end
        table.sort(keys)
        for _,name in ipairs(keys) do
            local value = tab[name]
            name = encode(tostring(name))
            if key then
                name = string.format('%s[%s]', tostring(key), tostring(name))
            end
            if type(value) == 'table' then
                query[#query+1] = helpers.build_query(value, sep, name)
            else
                local value = encodeValue(tostring(value))
                if value ~= "" then
                    query[#query+1] = string.format('%s=%s', name, value)
                else
                    query[#query+1] = name
                end
            end
        end
        return table.concat(query, sep)
    end

    function helpers.get_search_url()
        local base_url = 'https://www.googleapis.com/customsearch/v1?'
        local params = {
            key     = ngx.var.GOOGLE_SEARCH_KEY,
            cx      = ngx.var.GOOGLE_SEARCH_ENGINE_ID,
            q       = 'demotivational',
            imgType = 'photo'
        }
        local url = base_url .. helpers.build_query(params)
        return url
    end

    return helpers
end

return new()