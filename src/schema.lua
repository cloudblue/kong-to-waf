local typedefs = require "kong.db.schema.typedefs"

return {
    name = "kong-to-waf",
    fields = {
        { consumer = typedefs.no_consumer },
        { config = {
            type = "record",
            fields = {
                { mode = { type = "string", default = "full", one_of = { "disabled", "only-log", "full" } } },
                { waf_method = { type = "string", default = "GET", one_of = { "GET" } } },
                { waf_proto = { type = "string", default = "http", one_of = { "http" } } },
                -- TODO: Add support for https
                { waf_host = { type = "string", default = "localhost" } },
                { waf_port = { type = "number", default = 80 } },
                { waf_uri = { type = "string", required = false } },
                { waf_timeout = { type = "number", default = 10000 } },
                { waf_keepalive = { type = "number", default = 60000 } },
                { waf_conn_pool_size = { type = "number", default = 6 } },
                -- TODO: Add track ID
            },
        },
      },
    },
}
