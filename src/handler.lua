local access = require "kong.plugins.kong-to-waf.access"


local KongToWAF = {
    VERSION = "1.0.0",
    PRIORITY = 1090
}

function KongToWAF:access(config)
    access.execute(config)
end

return KongToWAF
